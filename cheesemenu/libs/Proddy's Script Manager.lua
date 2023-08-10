local ScriptName <const> = "Proddy's Script Manager (CheeseMenu)"
local Version <const> = "2.3.2"
local Exiting = false

local FileFMAP <const> = {}

local Paths <const> = {}
Paths.Root = utils.get_appdata_path("PopstarDevs", "2Take1Menu")
Paths.Cfg = Paths.Root .. "\\cfg"
Paths.LogFile = Paths.Root .. "\\" .. ScriptName .. ".log"
Paths.Scripts = Paths.Root .. "\\scripts"

local og_loadfile <const> = loadfile
local og__loadfile <const> = _loadfile
local function ploadfile(...)
	return og__loadfile(...) or og_loadfile(...)
end
local og_load <const> = load
local og_pcall <const> = _pcall
local io_open <const> = io.open
local os_date <const> = os.date
local string_format <const> = string.format
local system_wait <const> = system.wait

local basePrint <const> = print
local function print(...)
	basePrint(...)
	local success, result = og_pcall(function(...)
		local args = {...}
		if #args == 0 then
			return
		end

		local currTime = os_date("*t")
		local file <close> = io_open(Paths.LogFile, "a")

		for i=1,#args do
			file:write(string_format("[%02d-%02d-%02d %02d:%02d:%02d] <%s> %s\n", currTime.year, currTime.month, currTime.day, currTime.hour, currTime.min, currTime.sec, Version, tostring(args[i])))
		end

		file:close()
	end, ...)
	if not success then
		basePrint("Error writing log: " .. result)
	end
end

local notif <const> = menu.notify
local function notify(msg, colour)
	notif(msg, ScriptName .. " v" .. Version, nil, colour)
	print(msg)
end

if ProddysScriptManager then
	notify(ScriptName .. " already loaded.", 0xFF50C8F0)
	return
end

--notify(ScriptName .. " v" .. Version .. " loading...")

local function CloneTable(obj, seen)
	if type(obj) ~= 'table' then
		return obj
	end

	if seen and seen[obj] then
		return seen[obj]
	end

	local s = seen or {}
	local res = {}
	s[obj] = res

	for k, v in pairs(obj) do
		res[CloneTable(k, s)] = CloneTable(v, s)
	end

	return setmetatable(res, getmetatable(obj)) --Should definitely clone the metatable
end

local function Trim(s)
	local n = s:find"%S"
	return n and s:match(".*%S", n) or ""
end

local function FileNameWithoutExtension(FileName)
	local name = FileName:match("(.+)%.")
	return name or FileName
end

local ExcludedScripts <const> = {}
ExcludedScripts["autoexec.lua"] = true
ExcludedScripts["autoexec.luac"] = true
ExcludedScripts["cheesemenu.lua"] = true
ExcludedScripts[debug.getinfo(1, "S").source:sub(Paths.Scripts:len() + 3):lower()] = true

local Settings <const> = {}

function Settings.Save(SettingsFile, SettingsTbl)
	assert(SettingsFile, "Nil passed for SettingsFile to Settings.Save")
	assert(type(SettingsTbl) == "table", "Not a table passed for SettingsTbl to Settings.Save")
	local file <close> = io.open(Paths.Cfg .. "\\" .. SettingsFile .. ".cfg", "w")
	local keys = {}
	for k in pairs(SettingsTbl) do
		keys[#keys + 1] = k
	end
	table.sort(keys)
	for i=1,#keys do
		file:write(tostring(keys[i]) .. "=" .. tostring(SettingsTbl[keys[i]]) .. "\n")
	end
	file:close()
end

function Settings.Load(SettingsFile, SettingsTbl)
	assert(SettingsFile, "Nil passed for SettingsFile to Settings.Load")
	assert(type(SettingsTbl) == "table", "Not a table passed for SettingsTbl to Settings.Load")
	SettingsFile = Paths.Cfg .. "\\" .. SettingsFile .. ".cfg"
	if not utils.file_exists(SettingsFile) then
		return false
	end
	for line in io.lines(SettingsFile) do
		local key, value = line:match("^(.-)=(.-)$")
		if key and value then
			local num = tonumber(value)
			if num then
				value = num
			elseif value == "true" then
				value = true
			elseif value == "false" then
				value = false
			end
			num = tonumber(key)
			if num then
				key = num
			end
			SettingsTbl[key] = value
		end
	end
	return true
end

local FeatType <const> = {
	[2048] = "parent",
	[1] = "toggle",
	[512] = "action",
	[11] = "value_i",
	[131] = "value_f",
	[7] = "slider",
	[35] = "value_str",
	[522] = "action_value_i",
	[642] = "action_value_f",
	[518] = "action_slider",
	[546] = "action_value_str",
	[1034] = "autoaction_value_i",
	[1154] = "autoaction_value_f",
	[1030] = "autoaction_slider",
	[1058] = "autoaction_value_str",
}

local AutoloadTbl = {}
Settings.Load(ScriptName, AutoloadTbl)

local LoadedScripts = {}

local add_feature <const> = menu.add_feature
local add_player_feature <const> = menu.add_player_feature
local delete_feature <const> = menu.delete_feature
local delete_player_feature <const> = menu.delete_player_feature
local create_thread <const> = menu.create_thread
local delete_thread <const> = menu.delete_thread

local register_script_event_hook <const> = hook.register_script_event_hook
local remove_script_event_hook <const> = hook.remove_script_event_hook
local register_net_event_hook <const> = hook.register_net_event_hook
local remove_net_event_hook <const> = hook.remove_net_event_hook

local add_event_listener <const> = event.add_event_listener
local remove_event_listener <const> = event.remove_event_listener

local register_command <const> = console.register_command
local remove_command <const> = console.remove_command

local Parent <const> = menu_originals.add_feature("Proddy's Script Manager", "parent", menu.get_feature_by_hierarchy_key("local.script_features.cheese_menu").id)
local ParentId <const> = Parent.id
local FirstChild
local AutoloadFirstChild
local FilterFeat

-- menu_originals.add_feature("Trusted Mode", "parent", ParentId)

local AutoloadParent <const> = menu_originals.add_feature("Manage Autoload Scripts", "parent", ParentId)
local AutoloadParentId <const> = AutoloadParent.id

local assert <const> = assert
local error <const> = error
local type <const> = type

local UnloadScript

local function DeleteFeature(Feat)
	if Feat then
		if Feat.type == 2048 then
			for i=1,Feat.child_count do
				DeleteFeature(Feat.children[1])
			end
		elseif Feat.type == 1 then
			if Feat.data and type(Feat.data) == "table" and Feat.data.ScriptManager then
				print("Deleting script: " .. Feat.name)
				UnloadScript(Feat)
				print("Deleted script: " .. Feat.name)
			end
		end
		if Feat.activate_feat_func then
			delete_feature(Feat.id)
		else
			menu_originals.delete_feature(Feat.id, Feat.type == 2048 and Feat.child_count > 0)
		end
	end
end
local function DeletePlayerFeature(Feat)
	delete_player_feature(Feat.id)
end

local fid_to_filename <const> = {}

UnloadScript = function(f)
	if Exiting then return end
	if not f.data or type(f.data) ~= "table" or not f.data.ScriptManager then return end

	local Filename = fid_to_filename[f.id]

	print("Unloading script: " .. Filename)

	local success, result = og_pcall(function(data)
		if data.exits then
			for k,v in pairs(data.exits) do
				v({["code"]=69})
			end
		end

		if data.features then
			local ids = {}
			for k in pairs(data.features) do
				ids[#ids + 1] = k
			end
			table.sort(ids)
			for i = #ids,1,-1 do
				DeleteFeature(data.features[ids[i]])
			end
		end

		if data.player_features then
			local ids = {}
			for k in pairs(data.player_features) do
				ids[#ids + 1] = k
			end
			table.sort(ids)
			for i = #ids,1,-1 do
				DeletePlayerFeature(data.player_features[ids[i]])
			end
		end

		if data.threads then
			local ids = {}
			for k in pairs(data.threads) do
				ids[#ids + 1] = k
			end
			table.sort(ids)
			for i = #ids,1,-1 do
				delete_thread(ids[i])
			end
		end

		if data.script_hooks then
			local ids = {}
			for k in pairs(data.script_hooks) do
				ids[#ids + 1] = k
			end
			table.sort(ids)
			for i = #ids,1,-1 do
				remove_script_event_hook(ids[i])
			end
		end

		if data.net_hooks then
			local ids = {}
			for k in pairs(data.net_hooks) do
				ids[#ids + 1] = k
			end
			table.sort(ids)
			for i = #ids,1,-1 do
				remove_net_event_hook(ids[i])
			end
		end

		if data.events then
			for eventName,v in pairs(data.events) do
				local ids = {}
				for k in pairs(v) do
					ids[#ids + 1] = k
				end
				table.sort(ids)
				for i = #ids,1,-1 do
					remove_event_listener(eventName, ids[i])
				end
			end
		end

		if data.commands then
			for name in pairs(data.commands) do
				remove_command(name)
			end
		end
	end, f.data)

	LoadedScripts[Filename] = nil
	f.data = nil
	f.on = false

	if success then
		notify("Unloaded script: " .. Filename, 0xFF00FF00)
	else
		notify("Failed to unload script: " .. Filename .. "\n" .. result, 0xFF00FF00)
	end

	collectgarbage("collect")
end

-- modified
local limited_functions = {
	{
		namespace = "stats",
		table = stats,
		["stat_set_int"] = true,
		["stat_set_float"] = true,
		["stat_set_bool"] = true,
		["stat_set_i64"] = true,
		["stat_set_u64"] = true,
		["stat_set_masked_int"] = true,
		["stat_set_masked_bool"] = true,
	},
	{
		namespace = "script",
		table = script,
		["set_global_f"] = true,
		["set_global_i"] = true,
		["set_global_s"] = true,
		["set_local_f"] = true,
		["set_local_i"] = true,
		["set_local_s"] = true,
	},
	{
		namespace = "native",
		table = native,
		["call"] = true,
	},
	{
		namespace = "web",
		table = web,
		["post"] = true,
		["get"] = true,
		["request"] = true,
		["urlencode"] = true,
		["urldecode"] = true,
	},
	{
		namespace = "memory",
		table = memory,
		["get_any"] = true,
		["get_entity"] = true,
		["get_physical"] = true,
		["get_ped"] = true,
		["get_vehicle"] = true,
		["get_object"] = true,
		["get_pickup"] = true,
		["read_u64"] = true,
		["read_u32"] = true,
		["read_u16"] = true,
		["read_u8"] = true,
		["read_i64"] = true,
		["read_i32"] = true,
		["read_i16"] = true,
		["read_i8"] = true,
		["read_f32"] = true,
	},
}

local trusted_names <const> = {
	"Stats",
	"Globals / Locals",
	"Natives",
	"HTTP",
	"Memory"
}

local blocked_functions <const> = {
	stats = {},
	script = {},
	native = {},
	web = {},
	memory = {},
}

local namespace_to_child_num <const> = {
	stats = 3,
	script = 4,
	native = 5,
	web = 6,
	memory = 7,
}

for k, v in ipairs(limited_functions) do
	local namespace <const> = v.namespace
	for name, data in pairs(v) do
		if data then
			blocked_functions[namespace][name] = function(...)
				if trusted_mode_notification then
					menu.notify("Trusted Flag '"..trusted_names[k].."' is not enabled.\nFunction used: "..namespace..'.'..name, "Cheese Menu", 5, 0x00ffff)
				end
			end
		end
	end
end

local function remove_children_for_recursive(feat, feat_table)
	for _, child in pairs(feat.children) do
		if child.type >> 11 & 1 ~= 0 then
			remove_children_for_recursive(child)
		end
		delete_feature(child.id)
		feat_table[child.id] = nil
	end
end
--

local function LoadScript(f)
	if f.on then
		if not f.data then
			local Filename = fid_to_filename[f.id]
			local Filepath = Paths.Scripts .. "\\" .. Filename

			f.parent.name = "[R] "..Filename

			if not utils.file_exists(Filepath) then
				notify("Could not find script: " .. Filename,0xFF0000FF)
				LoadedScripts[Filename] = nil
				f.data = nil
				f.on = false
				return
			end

			print("Enabling script: " .. Filename)
			f.data = {}
			f.data.ScriptManager = true
			f.data.features = {}
			f.data.player_features = {}
			f.data.threads = {}
			f.data.script_hooks = {}
			f.data.net_hooks = {}
			f.data.events = {}
			f.data.exits = {}
			f.data.commands = {}

			local env = CloneTable(_G)
			function env.SetGlobal(Name, Value)
				assert(type(Name) == "string", "Arg #1 (Name) must be a string")

				_G[Name] = Value
				for i=FirstChild,Parent.child_count do
					local feat = Parent.children[i]
					if feat.data and feat.data.env then
						feat.data.env[Name] = Value
					end
				end
			end

			local parent_children <const> = f.parent.children
			for namespace, func_table in pairs(blocked_functions) do
				if not parent_children[namespace_to_child_num[namespace]].on then
					local env_namespace = env[namespace]
					for name, func in pairs(func_table) do
						env_namespace[name] = func
					end
				end
			end

			local trusted_mode = parent_children[2].on and 31 or
			(parent_children[3].on and eTrustedFlags.LUA_TRUST_STATS		or 0) |
			(parent_children[4].on and eTrustedFlags.LUA_TRUST_SCRIPT_VARS	or 0) |
			(parent_children[5].on and eTrustedFlags.LUA_TRUST_NATIVES		or 0) |
			(parent_children[6].on and eTrustedFlags.LUA_TRUST_HTTP			or 0) |
			(parent_children[7].on and eTrustedFlags.LUA_TRUST_MEMORY		or 0)

			function env.menu.is_trusted_mode_enabled(flag)
				if not flag then
					return trusted_mode & 7 == 7
				else
					return trusted_mode & flag == flag
				end
			end

			function env.menu.get_trust_flags()
				return trusted_mode
			end

			function env.menu.exit()
				menu.create_thread(function()
					local timer = utils.time_ms() + 10000
					while not LoadedScripts[Filename] and timer > utils.time_ms() do
						system.wait(0)
					end
					f.on = false
				end)
			end

			env.cheeseUIdata = cheeseUIdata

			env.menu.add_feature = function(...)
				local success, feat = og_pcall(add_feature, ...)
				if not success then
					print(feat)
					menu.notify(feat, ScriptName, 6, 0x0000FF)
					return false
				end
				if feat then
					f.data.features[#f.data.features+1] = feat
				end
				return feat
			end
			env.menu.add_player_feature = function(...)
				local success, feat = og_pcall(add_player_feature, ...)
				if not success then
					print(feat)
					menu.notify(feat, ScriptName, 6, 0x0000FF)
					return false
				end
				if feat then
					f.data.player_features[#f.data.player_features+1] = feat
				end
				return feat
			end
			env.menu.delete_feature = function(...)
				local feat <const> = f.data.features[...]
				if select(2, ...) and feat.type >> 11 & 1 ~= 0 then
					remove_children_for_recursive(feat, f.data.features)
				end
				local success = delete_feature(...)
				if success then
					f.data.features[...] = nil
				end
				return success
			end
			env.menu.delete_player_feature = function(id)
				local success = delete_player_feature(id)
				if success then
					f.data.player_features[id] = nil
				end
				return success
			end
			env.menu.create_thread = function(...)
				local id = create_thread(...)
				if id then
					f.data.threads[id] = true
				end
				return id
			end
			env.menu.delete_thread = function(id)
				local success = delete_thread(id)
				if success then
					f.data.threads[id] = nil
				end
				return success
			end
			env.hook.register_script_event_hook = function(...)
				local id = register_script_event_hook(...)
				if id then
					f.data.script_hooks[id] = true
				end
				return id
			end
			env.hook.remove_script_event_hook = function(id)
				local success = remove_script_event_hook(id)
				if success then
					f.data.script_hooks[id] = nil
				end
				return success
			end
			env.hook.register_net_event_hook = function(...)
				local id = register_net_event_hook(...)
				if id then
					f.data.net_hooks[id] = true
				end
				return id
			end
			env.hook.remove_net_event_hook = function(id)
				local success = remove_net_event_hook(id)
				if success then
					f.data.net_hooks[id] = nil
				end
				return success
			end
			env.event.add_event_listener = function(eventName, callback)
				local id = add_event_listener(eventName, callback)
				if id then
					f.data.events[eventName] = f.data.events[eventName] or {}
					f.data.events[eventName][id] = true
					if eventName == "exit" then
						f.data.exits[id] = callback
					end
				end
				return id
			end
			env.event.remove_event_listener = function(eventName, id)
				local success = remove_event_listener(eventName, id)
				if success and f.data.events[eventName] then
					f.data.events[eventName][id] = nil
					if eventName == "exit" then
						f.data.exits[id] = nil
					end
				end
				return success
			end
			env.console.register_command = function(name, ...)
				if register_command(name, ...) then
					f.data.commands[name] = true
					return true
				end
				return false
			end
			env.console.remove_command = function(name)
				if remove_command(name) then
					for i=FirstChild,Parent.child_count do
						local feat = Parent.children[i]
						if feat.data and feat.data.commands then
							feat.data.commands[name] = nil
						end
					end
					return true
				end
				return false
			end
			env.load = function(chunk, chunkname, mode, env2)
				return og_load(chunk, chunkname or "=(load)", mode or "bt", env2 or env)
			end
			env.dofile = function(filename)
				if not filename:find("C:") then
					filename = Paths.Root.."/"..filename
				end
				return ploadfile(filename, "bt", env)()
			end
			env.loadfile = function(filename, mode, env2)
				return ploadfile(filename, mode or "bt", env2 or env)
			end
			env._loadfile = function(filename, mode, env2)
				return ploadfile(filename, mode or "bt", env2 or env)
			end
			local loaders = {}
			local loaded = {}
			env.require = function(Library)
				assert(Library ~= nil, "You must pass a Library name")
				assert(type(Library) == "string", "Library name must be a string")
				if loaders[Library] then
					local status, result = og_pcall(loaders[Library])
					if status then
						if result == nil then
							return true
						else
							loaded[Library] = result
							return loaded[Library]
						end
					end
				end
				local libParts = {}
				for part in Library:gmatch("[^.]+") do
					libParts[#libParts + 1] = part
				end
				local subDirTbl = {}
				if #libParts > 1 then
					for i=1,#libParts-1 do
						subDirTbl[#subDirTbl + 1] = libParts[i]
					end
				end
				local subDir = table.concat(subDirTbl, "/") .. "/"
				local lib = libParts[#libParts]
				for rootDir in env.package.path:gmatch("[^;]+") do
					local path = rootDir:gsub("%?", subDir .. lib)
					if utils.file_exists(path) then
						local chunk, err = ploadfile(path, "bt", env)
						assert(chunk, "Failed to load \"" .. Library .. "\": " .. tostring(err))
						local status, result = og_pcall(chunk)
						assert(status, "Failed to exec  \"" .. Library .. "\": " .. tostring(result))
						loaders[Library] = chunk
						if result == nil then
							return true
						else
							loaded[Library] = result
							return loaded[Library]
						end
					end
				end
				error("Failed to find library with name \"" .. Library .. "\"")
			end
			env.clear_lib_cache = function(Library)
				if Library then
					local retVal = loaders[Library] ~= nil and loaded[Library] ~= nil
					loaders[Library] = nil
					loaded[Library] = nil
					return retVal
				else
					loaders = {}
					loaded = {}
					return true
				end
			end
			env.get_lib_cache = function()
				local cache = {}
				for k,v in pairs(loaded) do
					cache[k] = v
				end
				return cache
			end
			f.data.env = env

			local chunk, err = ploadfile(Filepath, "bt", f.data.env)
			if chunk then
				local status, result = og_pcall(chunk)
				if not status then
					menu.create_thread(UnloadScript, f)
					notify("Error executing script: " .. Filename .. "\n" .. tostring(result), 0xFF0000FF)
				else
					notify("Loaded script: " .. Filename, 0xFF00FF00)
					LoadedScripts[Filename] = true
				end
			else
				menu.create_thread(UnloadScript, f)
				notify("Error loading script: " .. Filename .. "\n" .. err, 0xFF0000FF)
			end
		end
	else
		f.parent.name = fid_to_filename[f.id]
		if f.data then
			menu.create_thread(UnloadScript, f)
		end
	end
end

local function CaseInsensitiveSort(a, b)
	return tostring(a):lower() < tostring(b):lower()
end

local FMAP_hierarchy = {}
local function FMAP_add_feature(...)
	local feat <const> = menu_originals.add_feature(...)
	if feat.name ~= "Run" then
		local tosParent = tostring(feat.parent)
		local hierarchy_key <const> = (FMAP_hierarchy[tosParent] and (FMAP_hierarchy[tosParent] .. " > ") or "") .. feat.name
		FMAP_hierarchy[tostring(feat)] = hierarchy_key
		FileFMAP[hierarchy_key] = feat
	end
	return feat
end

local function LoadScripts(feat)
	if FilterFeat then
		FilterFeat.data = ""
		FilterFeat.name = "Filter: <None>"
	end

	local files = utils.get_all_files_in_directory(Paths.Scripts, "lua")
	local files2 = {}
	for i=1,#files do
		files2[files[i]] = true
	end
	local files3 = utils.get_all_files_in_directory(Paths.Scripts, "luac")
	for i=1,#files3 do
		if not files2[files3[i]] then
			files[#files + 1] = files3[i]
			files2[files3[i]] = true
		end
	end
	table.sort(files, CaseInsensitiveSort)
	local threads = {}
	for i=Parent.child_count,FirstChild,-1 do
		if not files2[fid_to_filename[Parent.children[i].children[1].id]] then
			threads[#threads + 1] = create_thread(DeleteFeature, Parent.children[i])
		else
			files2[fid_to_filename[Parent.children[i].children[1].id]] = false
			Parent.children[i].hidden = false
		end
	end
	for i=AutoloadParent.child_count,AutoloadFirstChild,-1 do
		threads[#threads + 1] = create_thread(DeleteFeature, AutoloadParent.children[i])
	end
	local waiting = true
	while waiting do
		local running = false
		for i=1,#threads do
			running = running or (not menu.has_thread_finished(threads[i]))
		end
		waiting = running
		system_wait(0)
	end
	for i=1,#files do
		if not ExcludedScripts[files[i]:lower()] then
			if files2[files[i]] then
				local parent <const> = FMAP_add_feature(files[i], "parent", ParentId).id
				local run <const> = menu_originals.add_feature("Run", "toggle", parent, LoadScript, f)
				fid_to_filename[run.id] = files[i]
				FMAP_add_feature("Spoof Trusted Modes", "toggle", parent)
				for k, v in pairs(trusted_names) do
					FMAP_add_feature(v, "toggle", parent)
				end
			end
			local autoloadFeat = menu_originals.add_feature(files[i], "value_i", AutoloadParentId)
			autoloadFeat.min = 1
			autoloadFeat.max = 999
			autoloadFeat.mod = 1
			local val = AutoloadTbl[files[i]]
			if val then
				autoloadFeat.value = type(val) == "number" and val or 1
				autoloadFeat.on = true
			else
				autoloadFeat.value = 1
			end
		end
	end
end

local ExitFeat = menu_originals.add_feature("Exit Listener", "toggle", ParentId, function(f)
	if not f.on then
		print("Exit Listener Feat Off")
		Exiting = true
	end
end)
ExitFeat.hidden = true
ExitFeat.on = true

local delayFeat

menu_originals.add_feature("Save Autoload Scripts", "action", AutoloadParentId, function(f)
	AutoloadTbl = {
		["autoload_delay_between_scripts"] = delayFeat.value
	}
	for i=AutoloadFirstChild,AutoloadParent.child_count do
		local child = AutoloadParent.children[i]
		if child.on then
			AutoloadTbl[child.name] = child.value
		end
	end
	Settings.Save(ScriptName, AutoloadTbl)
	notify("Saved autoload scripts.", 0xFF00FF00)
end)

delayFeat = menu_originals.add_feature("Delay between scripts (ms)", "action_value_i", AutoloadParentId, function(f)
	local r, s
	repeat
		r, s = input.get("Enter delay", f.value, 4, eInputType.IT_NUM)
		if r == 2 then return HANDLER_POP end
		system_wait(0)
	until r == 0

	local num = tonumber(s)
	if num and num >= f.min and num <= f.max then
		f.value = num
	end
end)
delayFeat.min = 0
delayFeat.max = 1000
delayFeat.mod = 1
local delayVal = AutoloadTbl["autoload_delay_between_scripts"]
if type(delayVal) ~= "number" or delayVal < delayFeat.min then
	delayVal = delayFeat.min
elseif delayVal > delayFeat.max then
	delayVal = delayFeat.max
end
delayFeat.value = delayVal

local RefreshFeat <const> = menu_originals.add_feature("Refresh Scripts", "action", ParentId, function(f)
	LoadScripts(f)
	notify("Refreshed scripts list.", 0xFF00FF00)
end)

local function FocusFeat(f)
	if f.data.parent then
		f.data.parent:toggle()
	end
	f.data:select()
end

local function ToggleFeat(f)
	f.data:select()
	f.parent:toggle()
end

local SearchParentId <const> = menu_originals.add_feature("Search Script Features", "parent", ParentId).id
menu_originals.add_feature("Filter: <None>", "action", SearchParentId, function(f)
	local r, s
	repeat
		r, s = input.get("Enter search query", f.data, 64, 0)
		if r == 2 then return HANDLER_POP end
		system_wait(0)
	until r == 0

	local threads = {}
	for i=f.parent.child_count,2,-1 do
		threads[#threads + 1] = create_thread(DeleteFeature, f.parent.children[i])
	end

	local waiting = true
	while waiting do
		local running = false
		for i=1,#threads do
			running = running or (not menu.has_thread_finished(threads[i]))
		end
		waiting = running
		system_wait(0)
	end

	s = Trim(s)
	if s:len() == 0 then
		f.data = ""
		f.name = "Filter: <None>"
		return HANDLER_POP
	end

	local count = 0
	for i=7,RefreshFeat.parent.child_count do
		local child = RefreshFeat.parent.children[i]
		child = child.type == 2048 and child.children[1] or nil
		if child and child.data and child.data.features and type(child.data.features) == "table" then
			--[[ print(child, "success")
			print(child.data.features[1]) ]]
			for j=1,#child.data.features do
				local feat = child.data.features[j]
				--[[ print(feat.name) ]]
				if feat then
					if feat.name:lower():find(s:lower(), 1, true) then
						if feat.type == 2048 then
							menu_originals.add_feature(FileNameWithoutExtension(fid_to_filename[child.id]) .. " | " .. feat.name, "parent", SearchParentId, ToggleFeat).data = feat
						else
							menu_originals.add_feature(FileNameWithoutExtension(fid_to_filename[child.id]) .. " | " .. feat.name, "action", SearchParentId, FocusFeat).data = feat
						end
						count = count + 1
					end
				end
			end
		end
	end

	f.data = s
	f.name = "Filter: <" .. s .. "> (" .. count .. ")"
end).data = ""

FilterFeat = menu_originals.add_feature("Filter: <None>", "action", ParentId, function(f)
	local r, s
	repeat
		r, s = input.get("Enter search query", f.data, 64, 0)
		if r == 2 then return HANDLER_POP end
		system_wait(0)
	until r == 0

	s = Trim(s)
	if s:len() == 0 then
		f.data = ""
		f.name = "Filter: <None>"
		for i=f.parent.child_count,FirstChild,-1 do
			f.parent.children[i].hidden = false
		end
		return HANDLER_POP
	end

	local count = 0
	for i=f.parent.child_count,FirstChild,-1 do
		if f.parent.children[i].name:lower():find(s, 1, true) then
			f.parent.children[i].hidden = false
			count = count + 1
		else
			f.parent.children[i].hidden = true
		end
	end

	f.data = s
	f.name = "Filter: <" .. s .. "> (" .. count .. ")"
end)
FilterFeat.data = ""

local save_trusted <const> = menu_originals.add_feature("Save Trusted Flags", "action", ParentId, function()
	gltw.write_fmap(FileFMAP, "Trusted Flags", "scripts/cheesemenu/", nil, true)
	menu.notify("Saved Trusted Flags", ScriptName, 2, 0xFF00FF00)
end)

ProddysScriptManager = true

create_thread(function(f)
	FirstChild = Parent.child_count + 1
	AutoloadFirstChild = AutoloadParent.child_count + 1
	LoadScripts(f)

	if not gltw.read_fmap(FileFMAP, "Trusted Flags", "scripts/cheesemenu/", true) then
		print('Failed to find `Trusted Flags.lua`, creating file...')
		save_trusted:toggle()
	end

	local delay = 0
	local autoload = {}
	for k,v in pairs(AutoloadTbl) do
		if k == "autoload_delay_between_scripts" then
			if type(v) == "number" and v >= 0 then
				delay = v
			end
		else
			if type(v) ~= "number" then v = 1 end
			autoload[v] = autoload[v] or {}
			autoload[v][#autoload[v] + 1] = k
		end
	end

	print("Autoloading with delay: " .. delay)

	if #autoload > 0 then
		local scripts = {}
		for i=FirstChild,Parent.child_count do
			local feat = Parent.children[i]
			scripts[feat.name] = feat.children[1]
		end

		local ids = {}
		for k in pairs(autoload) do
			ids[#ids + 1] = k
		end
		table.sort(ids)

		for i=1,#ids do
			local tbl = autoload[ids[i]]
			for j=1,#tbl do
				local script = scripts[tbl[j]]
				if script then
					system_wait(delay)
					print("Enabled autoload script: " .. script.parent.name)
					script.on = true
				end
			end
		end
	end
end, RefreshFeat)

--notify(ScriptName .. " v" .. Version .. " loaded.", 0xFF0FF00)
