--Made by GhostOne

--local Feats = {}
local features = {OnlinePlayers = {}}
local currentMenu = features
local func = {}
local stuff = {
	scroll = 1,
	scrollHiddenOffset = 0,
	previousMenus = {},
	threads = {},
	path = {
		scripts = utils.get_appdata_path("PopstarDevs", "2Take1Menu").."\\scripts\\"
	},
	hotkeys = {},
	hotkeys_to_vk = {},
	char_codes = {
		["0"] = 0x30,
		["1"] = 0x31,
		["2"] = 0x32,
		["3"] = 0x33,
		["4"] = 0x34,
		["5"] = 0x35,
		["6"] = 0x36,
		["7"] = 0x37,
		["8"] = 0x38,
		["9"] = 0x39,
		["A"] = 0x41,
		["B"] = 0x42,
		["C"] = 0x43,
		["D"] = 0x44,
		["E"] = 0x45,
		["F"] = 0x46,
		["G"] = 0x47,
		["H"] = 0x48,
		["I"] = 0x49,
		["J"] = 0x4A,
		["K"] = 0x4B,
		["L"] = 0x4C,
		["M"] = 0x4D,
		["N"] = 0x4E,
		["O"] = 0x4F,
		["P"] = 0x50,
		["Q"] = 0x51,
		["R"] = 0x52,
		["S"] = 0x53,
		["T"] = 0x54,
		["U"] = 0x55,
		["V"] = 0x56,
		["W"] = 0x57,
		["X"] = 0x58,
		["Y"] = 0x59,
		["Z"] = 0x5A,
		["NUM0"] = 0x60,
		["NUM1"] = 0x61,
		["NUM2"] = 0x62,
		["NUM3"] = 0x63,
		["NUM4"] = 0x64,
		["NUM5"] = 0x65,
		["NUM6"] = 0x66,
		["NUM7"] = 0x67,
		["NUM8"] = 0x68,
		["NUM9"] = 0x69,
		["Space"] = 0x20,
		[";"] = 0xBA,
		["PLUS"] = 0xBB,
		[","] = 0xBC,
		["-"] = 0xBD,
		["DOT"] = 0xBE,
		["/"] = 0xBF,
		["`"] = 0xC0,
		["LSQREBRACKET"] = 0xDB,
		["\\"] = 0xDC,
		["RSQREBRACKET"] = 0xDD,
		["QUOTE"] = 0xDE,
		["NUM*"] = 0x6A,
		["NUMPLUS"] = 0x6B,
		["NUM-"] = 0x6D,
		["NUMDEL"] = 0x6E,
		["NUM/"] = 0x6F,
		["PAGEUP"] = 0x21,
		["PAGEDOWN"] = 0x22,
		["END"] = 0x23,
		["HOME"] = 0x24,
		["SCROLLLOCK"] = 0x91,
		["LEFTARROW"] = 0x25,
		["UPARROW"] = 0x26,
		["RIGHTARROW"] = 0x27,
		["DOWNARROW"] = 0x28,
		["SELECT"] = 0x29,
		["INS"] = 0x2D,
		["DEL"] = 0x2E,
		["PAUSE"] = 0x13,
		["CAPSLOCK"] = 0x14,
		["BACKSPACE"] = 0x08,
		["LSHIFT"] = 0xA0,
		["RSHIFT"] = 0xA1,
		["LCONTROL"] = 0xA2,
		["RCONTROL"] = 0xA3,
		["LALT"] = 0xA4,
		["RALT"] = 0xA5,
		["F1"] = 0x70,
		["F2"] = 0x71,
		["F3"] = 0x72,
		["F4"] = 0x73,
		["F5"] = 0x74,
		["F6"] = 0x75,
		["F7"] = 0x76,
		["F8"] = 0x77,
		["F9"] = 0x78,
		["F10"] = 0x79,
		["F11"] = 0x7A,
		["F12"] = 0x7B,
		["F13"] = 0x7C,
		["F14"] = 0x7D,
		["F15"] = 0x7E,
		["F16"] = 0x7F,
		["F17"] = 0x80,
		["F18"] = 0x81,
		["F19"] = 0x82,
		["F20"] = 0x83,
		["F21"] = 0x84,
		["F22"] = 0x85,
		["F23"] = 0x86,
		["F24"] = 0x87,
	},
	hotkey_notifications = {toggle = true, action = false},
	drawScroll = 0,
	maxDrawScroll = 0,
	menuData = {
		menuToggle = false,
		x = 0.5,
		y = 0.5680555555,
		width = 0.2,
		height = 0.305,
		header = "cheese_menu",
		feature_offset = 0.0270833333333333,
		feature_scale = {x = 0.2, y = 0.025},
		color = {},
		files = {},
		background_sprite = {
			sprite = nil,
			size = 1,
			loaded_sprites = {},
			offset = {x = 0, y = 0}
		},
		set_max_features = function(self, int)
			int = math.floor(int+0.5) self.height = int * self.feature_offset
		end
	}
}

stuff.menuData.color = {
	background = {r = 0, g = 0, b = 0, a = 125},
	sprite = 0xe6ffffff, feature = {r = 255, g = 255, b = 255, a = 125},
	feature_selected = {r = 255, g = 255, b = 255, a = 125},
	text_selected = {r = 255, g = 200, b = 0, a = 180},
	text = {r = 255, g = 255, b = 255, a = 180},
}

stuff.path.cheesemenu = stuff.path.scripts.."cheesemenu\\"
for k, v in pairs(utils.get_all_sub_directories_in_directory(stuff.path.cheesemenu)) do
	stuff.path[v] = stuff.path.cheesemenu..v.."\\"
end

stuff.menuData.background_sprite.fit_size_to_width = function(self)
	self.size = stuff.menuData.width*graphics.get_screen_width()/scriptdraw.get_sprite_size(func.load_sprite(self.sprite, stuff.path.background, stuff.menuData.background_sprite.loaded_sprites)).x
end
stuff.menuData.background_sprite.fit_size_to_height = function(self)
	self.size = stuff.menuData.height*graphics.get_screen_height()/scriptdraw.get_sprite_size(func.load_sprite(self.sprite, stuff.path.background, stuff.menuData.background_sprite.loaded_sprites)).y
end

stuff.menuData.files.headers = {}
for k, v in pairs(utils.get_all_files_in_directory(stuff.path.header, "png")) do
	stuff.menuData.files.headers[#stuff.menuData.files.headers + 1] = v:sub(1, #v - 4)
end
for k, v in pairs(utils.get_all_sub_directories_in_directory(stuff.path.header)) do
	stuff.menuData.files.headers[#stuff.menuData.files.headers + 1] = v
end

stuff.menuData.files.ui = {}
for k, v in pairs(utils.get_all_files_in_directory(stuff.path.ui, "lua")) do
	stuff.menuData.files.ui[k] = v:sub(1, #v - 4)
end

stuff.menuData.files.background = {}
for k, v in pairs(utils.get_all_files_in_directory(stuff.path.background, "png")) do
	stuff.menuData.files.background[k] = v:sub(1, #v - 4)
end

stuff.menuData_methods = {
	set_color = function(self, colorName, r, g, b, a)
		assert(self[colorName], "field "..colorName.." does not exist")
		local colors = {r = r or false, g = g or false, b = b or false, a = a or false}
		for k, v in pairs(colors) do
			if not v then
				if type(self[colorName]) == "table" then
					colors[k] = self[colorName][k]
				else
					colors[k] = func.convert_int_to_rgba(self[colorName], k)
				end
			end
		end
		for k, v in pairs(colors) do
			assert(v <= 255 and v >= 0, "attempted to set invalid "..k.." value to field "..colorName)
		end
		if type(self[colorName]) == "table" then
			self[colorName] = colors
		else
			self[colorName] = (colors.a << 24) + (colors.b << 16) + (colors.g << 8) + colors.r
		end
	end
}
function func.convert_rgba_to_int(r, g, b, a)
	if not a then
		a = 255
	end
	assert(r and g and b, "one or more of the r, g, b values is invalid")
	assert((a <= 255 and a >= 0) and (b <= 255 and b >= 0) and (g <= 255 and g >= 0) and (r <= 255 and r >= 0), "rgba values cannot be more than 255 or less than 0")
	return (a << 24) + (b << 16) + (g << 8) + r
end

stuff.conversionValues = {a = 24, b = 16, g = 8, r = 0}
function func.convert_int_to_rgba(...)
	local int, val1, val2, val3, val4 = ...
	local values = {val1, val2, val3, val4}
	
	for k, v in pairs(values) do
		values[k] = int >> stuff.conversionValues[v] & 0xff
	end
	return table.unpack(values)
end
setmetatable(stuff.menuData.color, {__index = stuff.menuData_methods})

stuff.input = require("cheesemenu.libs.Get Input")
require("cheesemenu.libs.GLTW")

gltw.read("hotkey notifications", stuff.path.hotkeys, stuff.hotkey_notifications, true)
stuff.hotkeys = gltw.read("hotkeys", stuff.path.hotkeys, nil, true) or {}
stuff.hierarchy_key_to_hotkey = {}
for k, v in pairs(stuff.hotkeys) do
	local string_to_vk = {}
	for char in k:gmatch("%|*([^%|]+)%|*") do
		string_to_vk[#string_to_vk+1] = stuff.char_codes[char]
	end
	stuff.hotkeys_to_vk[k] = string_to_vk

	if type(v) == "table" then
		for i, e in pairs(v) do
			stuff.hierarchy_key_to_hotkey[i] = k
		end
	end
end

--local originalGetInput = input.get
if stuff.input then
	function input.get(title, default, len, Type)
		local originalmenuToggle = stuff.menuData.menuToggle
		stuff.menuData.menuToggle = false
		local status, gottenInput = stuff.input.getInput(title, default, len, Type)
		while func.get_key(0x0D):is_down() do
			system.wait(0)
		end
		stuff.menuData.menuToggle = originalmenuToggle
		return status, gottenInput
	end
end

-- Had a lil look at kek's menu cause the functions apparently don't exist or something
stuff.rawset = function(t, k, v)
	local metatable = getmetatable(t)
	local __newindex = metatable.__newindex
	metatable.__newindex = nil
	t[k] = v
	metatable.__newindex = __newindex
end

stuff.rawget = function(t, k)
	local metatable = getmetatable(t)
	local __index = getmetatable(t).__index
	metatable.__index = nil
	local item = t[k]
	metatable.__index = __index
	return item
end
--

stuff.featMetaTable = {
	__index = function(t, k)
		if k == "value" or k == "min" or k == "mod" or k == "max" or k == "str_data" or k == "type" or k == "id" or k == "on" then
			if t.feats and k ~= "str_data" and k ~= "type" and k ~= "id" then
				if next(t.feats) then
					local pfeats = {}
					for i, e in pairs(t.feats) do
						pfeats[i] = stuff.rawget(e, "real_"..k)
					end
					return pfeats
				else
					menu.notify("feats is empty")
				end
			else
				return stuff.rawget(t, "real_"..k)
			end
		else
			return stuff.rawget(t, k)
		end
	end,

	__newindex = function(t, k, v)
		assert(k ~= "str_data", "'str_data' is read only")
		assert(k ~= "type", "'type' is read only")
		assert(k ~= "id", "'id' is read only")
		if k == "on" and type(v) == "boolean" then
			stuff.rawset(t, "real_on", v)
			if v then
				t:activate_feat_func()
			end
			if next(t.feats or {}) then
				for i = 0, 31 do
					if player.is_player_valid(i) or v == false then
						t.feats[i]["on"] = v
					end
				end
			end
		elseif k == "value" or k == "min" or k == "mod" or k == "max" then
			assert(tonumber(v), "tried to set "..k.." property to a non-number value")
			v = tonumber(v)
			if stuff.type_id.id_to_name[t.type]:match("_i") or stuff.type_id.id_to_name[t.type]:match("value_str") then
				v = v + 0.5
				v = math.floor(v)
				stuff.rawset(t, "real_"..k, v)
			elseif stuff.type_id.id_to_name[t.type]:match("_f") then
				v = (v * 10000) + 0.5
				v = math.floor(v)
				v = v / 10000
				stuff.rawset(t, "real_"..k, v)
			end
		else
			stuff.rawset(t, k, v)
		end
	end
}

-- featMethods

stuff.set_val = function(self, valueType, val, dont_set_all)
	assert(tonumber(val), "tried to set "..valueType.." to a non-number value")
	val = tonumber(val)
	self[valueType] = val
	if self.feats and not dont_set_all then
		for k, v in pairs(self.feats) do
			v[valueType] = val
		end
	end
end

stuff.set_value = function(self, val, dont_set_all)
	stuff.set_val(self, "value", val, dont_set_all)
end
stuff.set_max = function(self, val, dont_set_all)
	stuff.set_val(self, "max", val, dont_set_all)
end
stuff.set_min = function(self, val, dont_set_all)
	stuff.set_val(self, "min", val, dont_set_all)
end
stuff.set_mod = function(self, val, dont_set_all)
	stuff.set_val(self, "mod", val, dont_set_all)
end

stuff.get_str_data = function(self)
	assert(stuff.type_id.id_to_name[self.type]:match("value_str"), "used get_str_data on a feature that isn't value_str")
	return self.str_data
end

stuff.set_str_data = function(self, stringTable)
	assert(type(stringTable) == "table", "tried to set str_data property to a non-table value")
	local numberedTable = {}
	for k, v in pairs(stringTable) do
		if type(k) ~= "number" then
			numberedTable = {}
			for k, v in pairs(stringTable) do
				numberedTable[#numberedTable + 1] = v
			end
			break
		end
		numberedTable = nil
	end
	self.real_str_data = numberedTable or stringTable
	if self.feats then
		for k, v in pairs(self.feats) do
			v.real_str_data = stringTable
		end
	end
end

stuff.toggle = function(self, bool)
	if stuff.type_id.id_to_name[self.type] == "toggle" then
		if bool ~= nil then
			self.real_on = bool
			self:activate_feat_func()
		else
			self.real_on = not self.real_on
			self:activate_feat_func()
		end
	else
		self:activate_feat_func()
	end
end

stuff.get_children = function(self)
	local children = {}
	for k, v in pairs(self) do
		if type(k) == "number" then
			children[#children + 1] = v
		end
	end
	return children
end

stuff.activate_feat_func = function(self)
	if not (self.thread) then
		self.thread = 0
	end
	if self.func and menu.has_thread_finished(self.thread) then
		self.thread = menu.create_thread(function()
			local continue = self:func(stuff.pid)
			while continue == HANDLER_CONTINUE and feat.real_on do
				system.wait(0)
				continue = self:func(stuff.pid)
			end
		end, nil)
	end
end
--

stuff.hotkey_feature_hierarchy_keys = {}

stuff.type_id = {
	name_to_id = {
		value_i=11,
		action_value_i=522,
		action=512,
		autoaction_value_str=1058,
		autoaction_value_f=1154,
		value_f=131,
		action_value_f=642,
		autoaction_slider=1030,
		autoaction_value_i=1034,
		action_value_str=546,
		toggle=1,
		value_str=35,
		action_slider=518,
		slider=7,
		parent=2048,
	},
	id_to_name = {
		[11]="toggle_value_i",
		[522]="action_value_i",
		[512]="action",
		[1058]="autoaction_value_str",
		[1154]="autoaction_value_f",
		[131]="toggle_value_f",
		[642]="action_value_f",
		[1030]="autoaction_slider_value_f",
		[1034]="autoaction_value_i",
		[546]="action_value_str",
		[1]="toggle",
		[35]="toggle_value_str",
		[518]="action_slider_value_f",
		[7]="toggle_slider_value_f",
		[2048]="parent",
	}
}

--Functions
function func.add_feature(nameOfFeat, TypeOfFeat, parentOfFeat, functionToDo, playerFeat)
	assert((type(nameOfFeat) == "string"), "invalid name in add_feature")
	assert((type(TypeOfFeat) == "string") and stuff.type_id.name_to_id[TypeOfFeat], "invalid type in add_feature")
	assert(((type(parentOfFeat) == "string") or (type(parentOfFeat) == "number")) or not parentOfFeat, "invalid parent id in add_feature")
	assert((type(functionToDo) == "function") or not functionToDo, "invalid function in add_feature")
	if not parentOfFeat then
		parentOfFeat = 0
	end
	TypeOfFeat = TypeOfFeat:gsub("slider", "value_f")
	local currentParent = features
	if playerFeat then
		currentParent = features["OnlinePlayers"]
	end

	local hierarchy_key = {}
	if parentOfFeat ~= 0 and parentOfFeat then
		for parentLine in parentOfFeat:gmatch("(%d+)-*") do
			if parentLine ~= "0" then
				currentParent = currentParent[tonumber(parentLine)]
				assert(currentParent.type == stuff.type_id.name_to_id["parent"], "parent id is not a parent feature")
				hierarchy_key[#hierarchy_key + 1] = currentParent.name
			end
		end
	end
	hierarchy_key[#hierarchy_key+1] = nameOfFeat
	hierarchy_key = table.concat(hierarchy_key, "."):gsub(" ", "_"):lower()

	currentParent[#currentParent + 1] = {name = nameOfFeat, real_type = stuff.type_id.name_to_id[TypeOfFeat], real_id = tostring(parentOfFeat).."-"..tostring(#currentParent + 1), parent = {id = currentParent.id or 0}, parent_id = currentParent.id or 0, playerFeat = playerFeat}
	currentParent[#currentParent].activate_feat_func = stuff.activate_feat_func
	currentParent[#currentParent].set_str_data = stuff.set_str_data
	currentParent[#currentParent].toggle = stuff.toggle
	currentParent[#currentParent].get_children = stuff.get_children
	currentParent[#currentParent].set_value = stuff.set_value
	currentParent[#currentParent].set_min = stuff.set_min
	currentParent[#currentParent].set_mod = stuff.set_mod
	currentParent[#currentParent].set_max = stuff.set_max
	currentParent[#currentParent].get_str_data = stuff.get_str_data
	setmetatable(currentParent[#currentParent], stuff.featMetaTable)
	if TypeOfFeat == "parent" then
		currentParent[#currentParent].children = {}
		setmetatable(currentParent[#currentParent].children, {__index = currentParent[#currentParent]:get_children()})
	end
	currentParent[#currentParent].thread = 0
	if TypeOfFeat:match("toggle") then
		currentParent[#currentParent].on = false
	end
	if TypeOfFeat:match(".*value_str.*") then
		currentParent[#currentParent].value = 0
		currentParent[#currentParent].real_str_data = {}
	elseif TypeOfFeat:match(".*value") then
		currentParent[#currentParent].value = 0
		currentParent[#currentParent].max = 0
		currentParent[#currentParent].min = 0
		currentParent[#currentParent].mod = 1
	end
	currentParent[#currentParent].hidden = false
	if functionToDo then
		currentParent[#currentParent]["func"] = functionToDo
	end
	if TypeOfFeat == "parent" then
		currentParent[#currentParent].child_count = 0
	end
	currentParent.child_count = 0
	for k, v in pairs(currentParent) do
		if type(k) == "number" then
			currentParent.child_count = currentParent.child_count + 1
		end
	end
	currentParent[#currentParent].hotkey = stuff.hierarchy_key_to_hotkey[hierarchy_key]
	currentParent[#currentParent].hierarchy_key = hierarchy_key
	if stuff.hotkey_feature_hierarchy_keys[hierarchy_key] then
		stuff.hotkey_feature_hierarchy_keys[hierarchy_key][#stuff.hotkey_feature_hierarchy_keys[hierarchy_key] + 1] = currentParent[#currentParent]
 	else
		stuff.hotkey_feature_hierarchy_keys[hierarchy_key] = {currentParent[#currentParent]}
	end
	return currentParent[#currentParent]
end

--player feature functions

function func.add_player_feature(nameOfFeat, TypeOfFeat, parentOfFeat, functionToDo)
	local pfeat = func.add_feature(nameOfFeat, TypeOfFeat, parentOfFeat, functionToDo, true)
	local featIds = {}
	pfeat.feats = {}
	if type(parentOfFeat) == "string" then
		for k, v in pairs(stuff.playerIds) do
			if type(k) == "number" then
				featIds[#featIds + 1] = v.id..parentOfFeat:sub(2, #parentOfFeat)
			end
		end
	end
	local currentParent = features
	local pfeatID = tonumber(pfeat.id:match("-(%d+)$"))
	if next(featIds) then
		for k, v in pairs(featIds) do
			currentParent = features
			for parentLine in v:gmatch("(%d+)-*") do
				if parentLine ~= "0" then
					currentParent = currentParent[tonumber(parentLine)]
				end
			end
			currentParent[pfeatID] = {}
			func.add_to_table(pfeat, currentParent[pfeatID], k - 1, nil, true)
			pfeat.feats[k - 1] = currentParent[pfeatID]
		end
	else
		for k, v in pairs(stuff.playerIds) do
			stuff.playerIds[k][pfeatID] = {}
			func.add_to_table(pfeat, stuff.playerIds[k][pfeatID], k, nil, true)
			pfeat.feats[k] = stuff.playerIds[k][pfeatID]
		end
	end
	return pfeat
end

function func.add_to_table(getTable, addToTable, playerid, override, setmeta)
	for k, v in pairs(getTable) do
		if type(v) == "table" then
			if type(addToTable[k]) ~= "table" then
				addToTable[k] = {}
			end
			if addToTable[k].real_on then
				addToTable[k].real_on = false
			end
			if v.type == stuff.type_id.name_to_id["parent"] then
				func.add_to_table(getTable[k], addToTable[k], playerid, override)
			else
				for i, e in pairs(getTable[k]) do
					if type(e) ~= "table" then
						if not addToTable[k][i] or override then
							addToTable[k][i] = e
						end
					end
				end
			end
			setmetatable(addToTable[k], getmetatable(getTable[k]))
			if v.name then
				if not getTable[k].feats then
					getTable[k].feats = {}
				end
				getTable[k].feats[playerid] = addToTable[k]
			end
		else
			if not addToTable[k] or override then
				addToTable[k] = v
			end
		end
	end
	if setmeta then
		if not getTable.feats then
			getTable.feats = {}
		end
		getTable.feats[playerid] = addToTable
		if addToTable.feats then
			addToTable.feats = nil
		end
		setmetatable(addToTable, getmetatable(getTable))
	end
end

function func.set_player_feat_parent(nameOfFeat, parentOfFeat, functionToDo)
	stuff.PlayerParent = func.add_feature(nameOfFeat, "parent", parentOfFeat, functionToDo)
	stuff.PlayerParent.playerFeat = true
	stuff.playerIds = {}
		for i = 0, 31 do
			stuff.playerIds[i] = func.add_feature(tostring(player.get_player_name(i)), "parent", stuff.PlayerParent.id, function(f)
				stuff.pid = i
			end)
			stuff.playerIds[i].pid = i
			func.add_to_table(features["OnlinePlayers"], stuff.playerIds[i], i)
			stuff.playerIds[i].hidden = not player.is_player_valid(i)
		end

	event.add_event_listener("player_join", function(listener)
		func.update_online_players()
	end)
	event.add_event_listener("player_leave", function(listener)
		func.update_online_players()
	end)
	return stuff.PlayerParent
end

function func.update_online_players()
	for k, v in pairs(stuff.playerIds) do
		if player.is_player_valid(k) then
			if not (v.name == player.get_player_name(k)) then
				stuff.playerIds[k].hidden = false
				stuff.playerIds[k].name = player.get_player_name(k)
				func.add_to_table(features["OnlinePlayers"], stuff.playerIds[k], k, true)
			end
		else
			stuff.playerIds[k].hidden = true
			stuff.playerIds[k].name = "Empty"
			func.add_to_table(features["OnlinePlayers"], stuff.playerIds[k], k, true)
		end
	end
end

--end of player feature functions

function func.deleted_or_hidden_parent_check(isDHcurrentMenu, previousParent)
	if next(stuff.previousMenus) then
		local parentBeforeDHparent
		if not isDHcurrentMenu then
			for k, v in pairs(stuff.previousMenus) do
				if parentBeforeDHparent then
					v = nil
				else
					if v.menu == previousParent then
						if v.menu.hidden then
							parentBeforeDHparent = k-1
							stuff.previousMenus[k] = nil
						end
					else
						parentBeforeDHparent = k-1
						stuff.previousMenus[k] = nil
					end
				end
			end
		end
		if isDHcurrentMenu then
			currentMenu = stuff.previousMenus[#stuff.previousMenus].menu
			stuff.scroll = stuff.previousMenus[#stuff.previousMenus].scroll
			stuff.drawScroll = stuff.previousMenus[#stuff.previousMenus].drawScroll
			stuff.scrollHiddenOffset = stuff.previousMenus[#stuff.previousMenus].scrollHiddenOffset
			stuff.previousMenus[#stuff.previousMenus] = nil
		end
	end
end

function func.get_feature_by_hierarchy_key(hierarchy_key)
	local feat = stuff.hotkey_feature_hierarchy_keys[hierarchy_key]
	if stuff.hotkey_feature_hierarchy_keys[hierarchy_key] then
		if stuff.hotkey_feature_hierarchy_keys[hierarchy_key][2] then
			return stuff.hotkey_feature_hierarchy_keys[hierarchy_key]
		else
			return stuff.hotkey_feature_hierarchy_keys[hierarchy_key][1]
		end
	end
end

function func.get_feature(id)
	if type(id) == "table" then
		id = id.id
	end
	local currentParent = features
	if id ~= 0 then
		for parentLine in id:gmatch("(%d+)-*") do
			if parentLine ~= "0" then
				currentParent = currentParent[tonumber(parentLine)]
			end
		end
	end
	return currentParent
end

function func.shift_children_id(parent, originalParentID)
	for k, v in pairs(parent) do
		if type(k) == "number" then
			local originalID = v.id
			v.real_id = parent.real_id..v.real_id:sub(#originalParentID + 1, #v.id)
			v.parent.id = parent.real_id
			v.parent_id = parent.real_id
			if v.type == stuff.type_id.name_to_id["parent"] then
				func.shift_children_id(v, originalID)
			end
		end
	end
end

function func.delete_feature(id)
	if type(id) == "table" then
		id = id.id
	end
	local Parents = features
	local previousParent
	if id ~= 0 then
		for parentLine in id:gmatch("(%d+)-*") do
			if parentLine ~= "0" then
				previousParent = Parents
				Parents = Parents[tonumber(parentLine)]
			end
		end
	end

	table.remove(previousParent, tonumber(id:match("%d+$")))
	for k, v in pairs(previousParent) do
		if type(k) == "number" then
			if type(v.id) ~= "nil" then
				if tonumber(v.id:match("%d+$")) > tonumber(id:match("%d+$")) then
					local originalID = v.id
					local id = v.id:match("%d+$")
					v.real_id = v.real_id:gsub("%d+$", "")
					v.real_id = v.real_id..tonumber(id - 1)
					if v.type == stuff.type_id.name_to_id["parent"] then
						func.shift_children_id(v, originalID)
					end
				end
			end
		end
	end
	func.deleted_or_hidden_parent_check(Parents == currentMenu, Parents)

	return true
end

function func.delete_player_feature(id)
	if type(id) == "table" then
		id = id.id
	end

	local Parents = {features["OnlinePlayers"]}
	if id ~= 0 then
		for parentLine in id:gmatch("(%d+)-*") do
			if parentLine ~= "0" then
				Parents[#Parents + 1] = Parents[#Parents][tonumber(parentLine)]
			end
		end
	end

	table.remove(Parents[#Parents - 1], tonumber(id:match("%d+$")))
	for k, v in pairs(Parents[#Parents - 1]) do
		if type(k) == "number" then
			if type(v.id) ~= "nil" then
				if tonumber(v.id:match("%d+$")) > tonumber(id:match("%d+$")) then
					local id = v.id:match("%d+$")
					v.real_id = v.real_id:gsub("%d+$", "")
					v.real_id = v.real_id..tonumber(id - 1)
				end
			end
		end
	end

	local featIds = {}
	for k, v in pairs(stuff.PlayerParent) do
		if type(k) == "number" then
			featIds[#featIds + 1] = v.id..id:sub(2, #id)
		end
	end
	for k, v in pairs(featIds) do
		func.delete_feature(v)
	end
end

function func.get_player_feature(id)
	local playerFeatTable = features["OnlinePlayers"]
	if id ~= 0 then
		for parentLine in id:gmatch("(%d+)-*") do
			if parentLine ~= "0" then
				playerFeatTable = playerFeatTable[tonumber(parentLine)]
			end
		end
	end
	return playerFeatTable
end


-- Huge thanks to Proddy for this function and for telling me of ways to improve this script
stuff.Keys = {}
function func.get_key(...)
    local args = {...}
    assert(#args > 0, "must give at least one key")
    local ID = table.concat(args, "|")
    if not stuff.Keys[ID] then
        local key = MenuKey()
        for i=1,#args do
           key:push_vk(args[i])
        end
        stuff.Keys[ID] = key
    end

    return stuff.Keys[ID]
end

function func.do_key(time, key, doLoopedFunction, functionToDo)
	if func.get_key(key):is_down() then
		functionToDo()
		local timer = utils.time_ms() + time
		while timer > utils.time_ms() and func.get_key(key):is_down() do
			system.wait(0)
		end
		while timer < utils.time_ms() and func.get_key(key):is_down() do
			if doLoopedFunction then
				functionToDo()
			end
			local timer = utils.time_ms() + 50
			while timer > utils.time_ms() do
				system.wait(0)
			end
		end
	end
end

stuff.header_ids = {}
function func.load_sprite(name, path, id_table)
	path = path or stuff.path.header
	id_table = id_table or stuff.header_ids
	name = tostring(name)
	assert(name, "invalid name")

	if name:match("%.png") then
		name = name:sub(1, #name - 4)
	end

	if not id_table[name] then
		if utils.dir_exists(path..name) then
			id_table[name] = {}
			local path = path..name.."\\"
			for i, e in pairs(utils.get_all_files_in_directory(path, "png")) do
				id_table[name][i] = scriptdraw.register_sprite(path..e)
			end
			id_table[name].fps = utils.get_all_files_in_directory(path, "txt")[1]
			id_table[name].fps = tonumber(id_table[name].fps:match("(%d*%.*%d+)%s+fps"))
		elseif utils.file_exists(path..name..".png") then
			id_table[name] = scriptdraw.register_sprite(path..name..".png")
		end
	end

	return id_table[name]
end

function func.save_ui(name)
	gltw.write(stuff.menuData, name, stuff.path.ui, {"menuToggle", "loaded_sprites", "files"})
end
gltw.read("default", stuff.path.ui, stuff.menuData, true)
function func.load_ui(name)
	gltw.read(name, stuff.path.ui, stuff.menuData)
end

function func.draw_outline(v2pos, v2size, color, thickness, even_thickness)
	local yThickness = thickness
	if even_thickness then
		yThickness = thickness*graphics.get_screen_width()/graphics.get_screen_height()
	end
	scriptdraw.draw_rect(v2(v2pos.x, v2pos.y - (v2size.y/2)), v2(v2size.x + thickness, yThickness), color)
	scriptdraw.draw_rect(v2(v2pos.x, v2pos.y + (v2size.y/2)), v2(v2size.x + thickness, yThickness), color)
	scriptdraw.draw_rect(v2(v2pos.x - (v2size.x/2), v2pos.y), v2(thickness, v2size.y - yThickness), color)
	scriptdraw.draw_rect(v2(v2pos.x + (v2size.x/2), v2pos.y), v2(thickness, v2size.y - yThickness), color)
end

function func.draw_feat(k, v, offset, hiddenOffset)
	stuff.drawFeatParams = {rectPos = v2(stuff.menuData.x, (stuff.menuData.y+stuff.menuData.height/2) - (stuff.menuData.height/2+0.0125)), textOffset = v2(-(stuff.menuData.feature_scale.x/2-0.003), -0.006), colorText = stuff.menuData.color.text, colorFeature = stuff.menuData.color.feature, textSize = ((graphics.get_screen_width()*graphics.get_screen_height())/3686400)*(0.45)+0.3}
	offset = offset or 0
	center = v.center or 0
	if center ~= 0 then
		center = center.x
		local stringWidth = 0.0799804 * graphics.get_screen_width()
		if (stringWidth / center) < stuff.drawFeatParams.textSize then
			stuff.drawFeatParams.textSize = stringWidth / center
			center = scriptdraw.get_text_size((v.name):gsub(" ", "."), stuff.drawFeatParams.textSize, 0).x
		end
	end
	if stuff.scroll == k + stuff.drawScroll then
		stuff.scrollHiddenOffset = hiddenOffset or stuff.scrollHiddenOffset
		stuff.drawFeatParams.colorText = stuff.menuData.color.text_selected
		stuff.drawFeatParams.colorFeature = stuff.menuData.color.feature_selected
	end
	if offset == 0 then
		scriptdraw.draw_rect(v2(stuff.drawFeatParams.rectPos.x*2-1, (stuff.drawFeatParams.rectPos.y + (stuff.menuData.feature_offset * k))*-2+1), v2(stuff.menuData.feature_scale.x*2, stuff.menuData.feature_scale.y*2), func.convert_rgba_to_int(stuff.drawFeatParams.colorFeature.r, stuff.drawFeatParams.colorFeature.g, stuff.drawFeatParams.colorFeature.b, stuff.drawFeatParams.colorFeature.a))
	end
	if v.type == stuff.type_id.name_to_id["parent"] then
		scriptdraw.draw_text(v["name"], v2((stuff.drawFeatParams.rectPos.x + stuff.drawFeatParams.textOffset.x)*2-1, (stuff.drawFeatParams.rectPos.y + stuff.drawFeatParams.textOffset.y + (stuff.menuData.feature_offset * k))*-2+1), v2(10, 10), stuff.drawFeatParams.textSize, func.convert_rgba_to_int(stuff.drawFeatParams.colorText.r, stuff.drawFeatParams.colorText.g, stuff.drawFeatParams.colorText.b, stuff.drawFeatParams.colorText.a), 0, 0)
		scriptdraw.draw_text(">>", v2((stuff.drawFeatParams.rectPos.x + stuff.drawFeatParams.textOffset.x + stuff.menuData.feature_scale.x - 0.02 - (center/graphics.get_screen_width())/2)*2-1, (stuff.drawFeatParams.rectPos.y + stuff.drawFeatParams.textOffset.y + (stuff.menuData.feature_offset * k))*-2+1), v2(10, 10), stuff.drawFeatParams.textSize, func.convert_rgba_to_int(stuff.drawFeatParams.colorText.r, stuff.drawFeatParams.colorText.g, stuff.drawFeatParams.colorText.b, stuff.drawFeatParams.colorText.a), 0, 0)
	elseif stuff.type_id.id_to_name[v.type]:match(".*action.*") then
		scriptdraw.draw_text(v["name"], v2((stuff.drawFeatParams.rectPos.x + stuff.drawFeatParams.textOffset.x + offset - (center/graphics.get_screen_width())/2)*2-1, (stuff.drawFeatParams.rectPos.y + stuff.drawFeatParams.textOffset.y + (stuff.menuData.feature_offset * k))*-2+1), v2(10, 10), stuff.drawFeatParams.textSize, func.convert_rgba_to_int(stuff.drawFeatParams.colorText.r, stuff.drawFeatParams.colorText.g, stuff.drawFeatParams.colorText.b, stuff.drawFeatParams.colorText.a), 0, 0)
	elseif stuff.type_id.id_to_name[v.type]:match(".*toggle.*") then
		func.draw_outline(v2((stuff.drawFeatParams.rectPos.x + stuff.drawFeatParams.textOffset.x + 0.00397)*2-1, (stuff.drawFeatParams.rectPos.y + (stuff.menuData.feature_offset * k))*-2+1), v2(0.015625, 0.015625*graphics.get_screen_width()/graphics.get_screen_height()), func.convert_rgba_to_int(stuff.drawFeatParams.colorText.r, stuff.drawFeatParams.colorText.g, stuff.drawFeatParams.colorText.b, stuff.drawFeatParams.colorText.a), 0.001953125, true)
		if v.real_on then
			scriptdraw.draw_rect(v2((stuff.drawFeatParams.rectPos.x + stuff.drawFeatParams.textOffset.x + 0.00397)*2-1, (stuff.drawFeatParams.rectPos.y + (stuff.menuData.feature_offset * k))*-2+1), v2(0.0140625, 0.0140625*graphics.get_screen_width()/graphics.get_screen_height()), func.convert_rgba_to_int(stuff.drawFeatParams.colorText.r, stuff.drawFeatParams.colorText.g, stuff.drawFeatParams.colorText.b, stuff.drawFeatParams.colorText.a))
		end
		scriptdraw.draw_text(v.name, v2((stuff.drawFeatParams.rectPos.x + stuff.drawFeatParams.textOffset.x + 0.011328125 - (center/graphics.get_screen_width())/2)*2-1, (stuff.drawFeatParams.rectPos.y + stuff.drawFeatParams.textOffset.y + (stuff.menuData.feature_offset * k))*-2+1), v2(10, 10), stuff.drawFeatParams.textSize, func.convert_rgba_to_int(stuff.drawFeatParams.colorText.r, stuff.drawFeatParams.colorText.g, stuff.drawFeatParams.colorText.b, stuff.drawFeatParams.colorText.a), 0, 0)
	end
	if v.type then
		if stuff.type_id.id_to_name[v.type]:match(".*value_str.*") and v.str_data then
			func.draw_feat(k, {name = "< "..tostring(v.str_data[v.real_value + 1]).." >", type = stuff.type_id.name_to_id["action"], center = scriptdraw.get_text_size(("< "..tostring(v.str_data[v.real_value + 1]).." >"):gsub(" ", "."), stuff.drawFeatParams.textSize, 0)}, stuff.menuData.feature_scale.x - 0.05)
		elseif stuff.type_id.id_to_name[v.type]:match(".*value_[if]") then
			func.draw_feat(k, {name = "< "..tostring(v.real_value).." >", type = stuff.type_id.name_to_id["action"], center = scriptdraw.get_text_size(("< "..tostring(v.real_value).." >"):gsub(" ", "."), stuff.drawFeatParams.textSize, 0)}, stuff.menuData.feature_scale.x - 0.05)
		end
	end
end

stuff.draw_current_menu = {frameCounter = 1, time = utils.time_ms() + 33, currentSprite = stuff.menuData.header}
function func.draw_current_menu()
	system.wait(0)
	local sprite = func.load_sprite(stuff.menuData.header)
	if stuff.draw_current_menu.currentSprite ~= stuff.menuData.header then
		stuff.draw_current_menu.currentSprite = stuff.menuData.header
		stuff.draw_current_menu.time = 0
	end
	stuff.drawHiddenOffset = 0
	for k, v in pairs(currentMenu) do
		if type(k) == "number" then
			if v.hidden then
				stuff.drawHiddenOffset = stuff.drawHiddenOffset + 1
			end
		end
	end
	if stuff.menuData.background_sprite.sprite then
		scriptdraw.draw_sprite(func.load_sprite(stuff.menuData.background_sprite.sprite, stuff.path.background), v2((stuff.menuData.x + stuff.menuData.background_sprite.offset.x)*2-1, (stuff.menuData.y+stuff.menuData.background_sprite.offset.y+stuff.menuData.height/2+0.01458)*-2+1), stuff.menuData.background_sprite.size, 0, func.convert_rgba_to_int(255, 255, 255, stuff.menuData.color.background.a))
	else
		scriptdraw.draw_rect(v2(stuff.menuData.x*2-1, (stuff.menuData.y+stuff.menuData.height/2)*-2+1), v2(stuff.menuData.width*2, stuff.menuData.height*2), func.convert_rgba_to_int(stuff.menuData.color.background.r, stuff.menuData.color.background.g, stuff.menuData.color.background.b, stuff.menuData.color.background.a))
	end
	if #currentMenu - stuff.drawHiddenOffset > ((stuff.menuData.height / stuff.menuData.feature_offset) - 1)  then
		stuff.maxDrawScroll = #currentMenu - stuff.drawHiddenOffset - math.floor(stuff.menuData.height / stuff.menuData.feature_offset)
	else
		stuff.maxDrawScroll = 0
	end
	if stuff.scroll > #currentMenu - stuff.drawHiddenOffset then
		stuff.scroll = #currentMenu - stuff.drawHiddenOffset
	elseif stuff.scroll < 1 then
		stuff.scroll = 1
	end
	local hiddenOffset = 0
	local drawnfeats = 0
	for k, v in ipairs(currentMenu) do
		if type(k) == "number" then
			if v.hidden then
				hiddenOffset = hiddenOffset + 1
			elseif k <= stuff.drawScroll + hiddenOffset + math.floor(stuff.menuData.height / (stuff.menuData.feature_offset-(stuff.menuData.feature_offset/20))) and k >= stuff.drawScroll + hiddenOffset + 1 then
				func.draw_feat(k - stuff.drawScroll - hiddenOffset, v, 0, hiddenOffset)
				drawnfeats = drawnfeats+1
			end
		end
	end

	if type(sprite) == "table" then
		if not sprite[stuff.draw_current_menu.frameCounter] then
			stuff.draw_current_menu.frameCounter = 1
		end
		if utils.time_ms() > stuff.draw_current_menu.time then
			if stuff.draw_current_menu.frameCounter < #sprite then
				stuff.draw_current_menu.frameCounter = stuff.draw_current_menu.frameCounter + 1
			else
				stuff.draw_current_menu.frameCounter = 1
			end
			stuff.draw_current_menu.time = utils.time_ms() + math.floor(1000 / sprite.fps)
		end
		sprite = sprite[stuff.draw_current_menu.frameCounter]
	end
	if sprite then
		scriptdraw.draw_sprite(sprite, v2(stuff.menuData.x * 2 - 1, ((stuff.menuData.y+stuff.menuData.height/2) - (stuff.menuData.height/2 + ((scriptdraw.get_sprite_size(sprite).y*((2.56 * stuff.menuData.width) * (1000 / scriptdraw.get_sprite_size(sprite).x)) / (2560 / graphics.get_screen_width()))/2)/graphics.get_screen_height()))*-2+1), ((2.56 * stuff.menuData.width) * (1000 / scriptdraw.get_sprite_size(sprite).x)) / (2560 / graphics.get_screen_width()), 0, stuff.menuData.color.sprite)
	end
end


--Hotkey functions
function func.get_hotkey(keyTable, vkTable)
	local current_key
	local excludedkeys = {}
	while not keyTable[1] do
		if func.get_key(0x1B):is_down() then
			return "escaped"
		end
		for v, k in pairs(stuff.char_codes) do
			if func.get_key(k):is_down() then
				if k ~= 0xA0 and k ~= 0xA1 and k ~= 0xA2 and k ~= 0xA3 and k ~= 0xA4 and k ~= 0xA5 then
					keyTable[1] = "NOMOD"
				end
				keyTable[#keyTable + 1] = v
				vkTable[#vkTable+1] = k
				current_key = k
				excludedkeys[k] = true
			end
		end
		system.wait(0)
	end

	while func.get_key(current_key):is_down() do
		for v, k in pairs(stuff.char_codes) do
			if func.get_key(k):is_down() and not excludedkeys[k] and k ~= 0xA0 and k ~= 0xA1 and k ~= 0xA2 and k ~= 0xA3 and k ~= 0xA4 and k ~= 0xA5 then
				excludedkeys[k] = true
				keyTable[#keyTable + 1] = v
				vkTable[#vkTable+1] = k
			end
		end
		system.wait(0)
	end

	while not func.get_key(0x1B):is_down() and not func.get_key(0x0D):is_down() do
		for v, k in pairs(stuff.char_codes) do
			if func.get_key(k):is_down() then
				return false
			end
		end
		system.wait(0)
	end

	if func.get_key(0x0D):is_down() then
		return true
	else
		return "escaped"
	end
end

function func.draw_hotkey(keyTable)
	while true do
		for i = 0, 360 do
			controls.disable_control_action(0, i, true)
		end
		local concatenated = table.concat(keyTable, "+")
		scriptdraw.draw_rect(v2(0, 0), v2(2, 2), 0x7D000000)
		scriptdraw.draw_text(concatenated, v2(0 - (scriptdraw.get_text_size(concatenated, 1).x/graphics.get_screen_width()), 0), v2(1, 1), 1, 0xffffffff, 1 << 1, 0)
		system.wait(0)
	end
end


function func.start_hotkey_process(feat)
	stuff.menuData.menuToggle = false
	local keyTable = {}
	local vkTable = {}

	local drawThread = menu.create_thread(func.draw_hotkey, keyTable)

	while func.get_key(0x7A):is_down() do
		system.wait(0)
	end

	local response
	repeat
		response = func.get_hotkey(keyTable, vkTable)
		if not response then
			for k, v in pairs(keyTable) do
				keyTable[k] = nil
			end
			for k, v in pairs(vkTable) do
				keyTable[k] = nil
			end
		end
	until response
	local keyString = table.concat(keyTable, "|")
	stuff.hotkeys_to_vk[keyString] = vkTable

	if response ~= "escaped" then
		if not stuff.hotkeys[keyString] then
			stuff.hotkeys[keyString] = {}
		end
		stuff.hotkeys[keyString][feat.hierarchy_key] = true
		feat.hotkey = keyString
	end

	menu.delete_thread(drawThread)
	while func.get_key(0x0D):is_down() or func.get_key(0x1B):is_down() do
		controls.disable_control_action(0, 200, true)
		system.wait(0)
	end
	controls.disable_control_action(0, 200, true)
	stuff.menuData.menuToggle = true
	gltw.write(stuff.hotkeys, "hotkeys", stuff.path.hotkeys, nil, true)
	return response ~= "escaped" and response
end

--End of functions

--key threads
menu.create_thread(function()
	while true do
		if stuff.menuData.menuToggle then
			func.draw_current_menu()
			controls.disable_control_action(0, 172, true)
			controls.disable_control_action(0, 27, true)
		else
			system.wait(0)
		end
	end
end, nil)

menu.create_thread(function()
	while true do
		func.do_key(500, 0x73, false, function() -- F4
			stuff.menuData.menuToggle = not stuff.menuData.menuToggle
		end)
		if stuff.menuData.menuToggle then
			func.do_key(500, 0x7A, false, function() -- F11
				if func.get_key(0x10):is_down() and stuff.hotkeys[currentMenu[stuff.scroll + stuff.scrollHiddenOffset].hotkey] then
					stuff.hotkeys[currentMenu[stuff.scroll + stuff.scrollHiddenOffset].hotkey][currentMenu[stuff.scroll + stuff.scrollHiddenOffset].hierarchy_key] = nil
					currentMenu[stuff.scroll + stuff.scrollHiddenOffset].hotkey = nil
					gltw.write(stuff.hotkeys, "hotkeys", stuff.path.hotkeys, nil, true)
					menu.notify("Removed "..currentMenu[stuff.scroll + stuff.scrollHiddenOffset].name.."'s hotkey")
				elseif func.get_key(0x11):is_down() then
					menu.notify(currentMenu[stuff.scroll + stuff.scrollHiddenOffset].name.."'s hotkey is "..(currentMenu[stuff.scroll + stuff.scrollHiddenOffset].hotkey or "none"))
				elseif not func.get_key(0x10, 0x11):is_down() then
					if stuff.hotkeys[currentMenu[stuff.scroll + stuff.scrollHiddenOffset].hotkey] then
						stuff.hotkeys[currentMenu[stuff.scroll + stuff.scrollHiddenOffset].hotkey][currentMenu[stuff.scroll + stuff.scrollHiddenOffset].hierarchy_key] = nil
					end
					if func.start_hotkey_process(currentMenu[stuff.scroll + stuff.scrollHiddenOffset]) then
						menu.notify("Set "..currentMenu[stuff.scroll + stuff.scrollHiddenOffset].name.."'s hotkey to "..currentMenu[stuff.scroll + stuff.scrollHiddenOffset].hotkey)
					end
				end
			end)
			func.do_key(500, 0x28, true, function() -- downKey
				if stuff.scroll + stuff.drawHiddenOffset >= #currentMenu then
					stuff.scroll = 1
					stuff.drawScroll = 0
				else
					stuff.scroll = stuff.scroll + 1
					if stuff.scroll - stuff.drawScroll >= ((stuff.menuData.height / stuff.menuData.feature_offset) - 2) and stuff.drawScroll < stuff.maxDrawScroll then
						stuff.drawScroll = stuff.drawScroll + 1
					end
				end
			end)
			func.do_key(500, 0x26, true, function() -- upKey
				if stuff.scroll <= 1 then
					stuff.scroll = #currentMenu
					stuff.drawScroll = stuff.maxDrawScroll
				else
					stuff.scroll = stuff.scroll - 1
					if stuff.scroll - stuff.drawScroll <= 2 and stuff.drawScroll > 0 then
						stuff.drawScroll = stuff.drawScroll - 1
					end
				end
			end)
			func.do_key(500, 0x0D, true, function() --enter
				if currentMenu[stuff.scroll + stuff.scrollHiddenOffset] then
					if currentMenu[stuff.scroll + stuff.scrollHiddenOffset].type == stuff.type_id.name_to_id["parent"] and not currentMenu[stuff.scroll + stuff.scrollHiddenOffset].hidden then
						stuff.previousMenus[#stuff.previousMenus + 1] = {menu = currentMenu, scroll = stuff.scroll, drawScroll = stuff.drawScroll, scrollHiddenOffset = stuff.scrollHiddenOffset}
						currentMenu = currentMenu[stuff.scroll + stuff.scrollHiddenOffset]
						currentMenu:activate_feat_func()
						stuff.scroll = 1
						system.wait(0)
						stuff.drawScroll = 0
						stuff.scrollHiddenOffset = 0
						while func.get_key(0x0D):is_down() do
							system.wait(0)
						end
					elseif stuff.type_id.id_to_name[currentMenu[stuff.scroll + stuff.scrollHiddenOffset].type]:match(".*action.*") and not currentMenu[stuff.scroll + stuff.scrollHiddenOffset].hidden then
						currentMenu[stuff.scroll + stuff.scrollHiddenOffset]:activate_feat_func()
					elseif stuff.type_id.id_to_name[currentMenu[stuff.scroll + stuff.scrollHiddenOffset].type]:match("toggle") and not currentMenu[stuff.scroll + stuff.scrollHiddenOffset].hidden then
						currentMenu[stuff.scroll + stuff.scrollHiddenOffset].real_on = not currentMenu[stuff.scroll + stuff.scrollHiddenOffset].real_on
						currentMenu[stuff.scroll + stuff.scrollHiddenOffset]:activate_feat_func()
					end
				else
					system.wait(100)
				end
			end)
			func.do_key(500, 0x08, false, function() --backspace
				if stuff.previousMenus[#stuff.previousMenus] then
					currentMenu = stuff.previousMenus[#stuff.previousMenus].menu
					stuff.scroll = stuff.previousMenus[#stuff.previousMenus].scroll
					stuff.drawScroll = stuff.previousMenus[#stuff.previousMenus].drawScroll
					stuff.scrollHiddenOffset = stuff.previousMenus[#stuff.previousMenus].scrollHiddenOffset
					stuff.previousMenus[#stuff.previousMenus] = nil
				end
			end)
			func.do_key(500, 0x25, true, function() -- left
				if currentMenu[stuff.scroll + stuff.scrollHiddenOffset] then
					if currentMenu[stuff.scroll + stuff.scrollHiddenOffset].real_value then
						if currentMenu[stuff.scroll + stuff.scrollHiddenOffset].str_data then
							if currentMenu[stuff.scroll + stuff.scrollHiddenOffset].real_value <= 0 then
								currentMenu[stuff.scroll + stuff.scrollHiddenOffset].real_value = #currentMenu[stuff.scroll + stuff.scrollHiddenOffset].str_data - 1
							else
								currentMenu[stuff.scroll + stuff.scrollHiddenOffset].real_value = currentMenu[stuff.scroll + stuff.scrollHiddenOffset].real_value - 1
							end
						else
							if tonumber(currentMenu[stuff.scroll + stuff.scrollHiddenOffset].real_value) <= currentMenu[stuff.scroll + stuff.scrollHiddenOffset].real_min then
								currentMenu[stuff.scroll + stuff.scrollHiddenOffset].real_value = currentMenu[stuff.scroll + stuff.scrollHiddenOffset].real_max
							else
								currentMenu[stuff.scroll + stuff.scrollHiddenOffset]:set_value(tonumber(currentMenu[stuff.scroll + stuff.scrollHiddenOffset].real_value) - currentMenu[stuff.scroll + stuff.scrollHiddenOffset].real_mod, true)
							end
						end
					end
					if currentMenu[stuff.scroll + stuff.scrollHiddenOffset].type then
						if stuff.type_id.id_to_name[currentMenu[stuff.scroll + stuff.scrollHiddenOffset].type]:match("auto") or (stuff.type_id.id_to_name[currentMenu[stuff.scroll + stuff.scrollHiddenOffset].type]:match("toggle_value") and currentMenu[stuff.scroll + stuff.scrollHiddenOffset].real_on) then
							currentMenu[stuff.scroll + stuff.scrollHiddenOffset]:activate_feat_func()
						end
					end
				end
			end)
			func.do_key(500, 0x27, true, function() -- right
				if currentMenu[stuff.scroll + stuff.scrollHiddenOffset] then
					if currentMenu[stuff.scroll + stuff.scrollHiddenOffset].real_value then
						if currentMenu[stuff.scroll + stuff.scrollHiddenOffset].str_data then
							if tonumber(currentMenu[stuff.scroll + stuff.scrollHiddenOffset].real_value) >= tonumber(#currentMenu[stuff.scroll + stuff.scrollHiddenOffset].str_data) - 1 then
								currentMenu[stuff.scroll + stuff.scrollHiddenOffset].real_value = 0
							else
								currentMenu[stuff.scroll + stuff.scrollHiddenOffset].real_value = currentMenu[stuff.scroll + stuff.scrollHiddenOffset].real_value + 1
							end
						else
							if tonumber(currentMenu[stuff.scroll + stuff.scrollHiddenOffset].real_value) >= currentMenu[stuff.scroll + stuff.scrollHiddenOffset].real_max then
								currentMenu[stuff.scroll + stuff.scrollHiddenOffset].real_value = currentMenu[stuff.scroll + stuff.scrollHiddenOffset].real_min
							else
								currentMenu[stuff.scroll + stuff.scrollHiddenOffset]:set_value(tonumber(currentMenu[stuff.scroll + stuff.scrollHiddenOffset].real_value) + currentMenu[stuff.scroll + stuff.scrollHiddenOffset].real_mod, true)
							end
						end
					end
					if currentMenu[stuff.scroll + stuff.scrollHiddenOffset].type then
						if stuff.type_id.id_to_name[currentMenu[stuff.scroll + stuff.scrollHiddenOffset].type]:match("auto") or (stuff.type_id.id_to_name[currentMenu[stuff.scroll + stuff.scrollHiddenOffset].type]:match("toggle_value") and currentMenu[stuff.scroll + stuff.scrollHiddenOffset].real_on) then
							currentMenu[stuff.scroll + stuff.scrollHiddenOffset]:activate_feat_func()
						end
					end
				end
			end)
		end
		if currentMenu.hidden or not currentMenu then
			currentMenu = stuff.previousMenus[#stuff.previousMenus].menu
			stuff.scroll = stuff.previousMenus[#stuff.previousMenus].scroll
			stuff.drawScroll = stuff.previousMenus[#stuff.previousMenus].drawScroll
			stuff.scrollHiddenOffset = stuff.previousMenus[#stuff.previousMenus].scrollHiddenOffset
			stuff.previousMenus[#stuff.previousMenus] = nil
		end
		system.wait(0)
	end
end, nil)


--Hotkey thread
menu.create_thread(function()
	while true do
		if native.call(0x5FCF4D7069B09026):__tointeger() ~= 1 then
			for k, v in pairs(stuff.hotkeys) do
				if func.get_key(table.unpack(stuff.hotkeys_to_vk[k])):is_down() and (not (func.get_key(0x10):is_down() or func.get_key(0x11):is_down() or func.get_key(0x12):is_down()) or not (k:match("NOMOD"))) then
					for k, v in pairs(stuff.hotkeys[k]) do
						if stuff.hotkey_feature_hierarchy_keys[k] then
							for k, v in pairs(stuff.hotkey_feature_hierarchy_keys[k]) do
								if v.on ~= nil then
									v.on = not v.on
									if stuff.hotkey_notifications.toggle then
										menu.notify("Turned "..v.name.." "..(v.on and "on" or "off"), "Cheese Menu", 3, 0x00c8ff)
									end
								else
									v:activate_feat_func()
									if stuff.hotkey_notifications.action then
										menu.notify("Activated "..v.name, "Cheese Menu", 3, 0x00c8ff)
									end
								end
							end
						end
					end
					system.wait(250)
				end
			end
		end
		system.wait(0)
	end
end, nil)
--End of threads
menu.notify("arrow keys and enter/backspace for navigation.", "Made by GhostOne\nF4 to open", 6, 0x00ff00)

local menu_configuration_features = {}
menu_configuration_features.cheesemenuparent = menu.add_feature("Cheese menu", "parent")

menu.add_feature("Save UI", "action", menu_configuration_features.cheesemenuparent.id, function()
	local status, name = input.get("name of ui", "", 25, 0)
	if status == 0 then
		func.save_ui(name)
	end
end)

menu.add_feature("Load UI", "action_value_str", menu_configuration_features.cheesemenuparent.id, function(f)
	func.load_ui(f.str_data[f.value + 1])
end):set_str_data(stuff.menuData.files.ui)

menu_configuration_features.menuXfeat = menu.add_feature("Menu pos X", "autoaction_value_i", menu_configuration_features.cheesemenuparent.id, function(f)
	if func.get_key(0x65):is_down() then
		local stat, num = input.get("num", "", 10, 3)
		stuff.menuData.x = num/graphics.get_screen_height()
		f.value = num
	end
	stuff.menuData.x = f.value/graphics.get_screen_width()
end)
menu_configuration_features.menuXfeat.max = graphics.get_screen_width()
menu_configuration_features.menuXfeat.mod = 1
menu_configuration_features.menuXfeat.min = -graphics.get_screen_width()
menu_configuration_features.menuXfeat.value = math.floor(stuff.menuData.x*graphics.get_screen_width())

menu_configuration_features.menuYfeat = menu.add_feature("Menu pos Y", "autoaction_value_i", menu_configuration_features.cheesemenuparent.id, function(f)
	if func.get_key(0x65):is_down() then
		local stat, num = input.get("num", "", 10, 3)
		stuff.menuData.y = num/graphics.get_screen_height()
		f.value = num
	end
	stuff.menuData.y = f.value/graphics.get_screen_height()
end)
menu_configuration_features.menuYfeat.max = graphics.get_screen_height()
menu_configuration_features.menuYfeat.mod = 1
menu_configuration_features.menuYfeat.min = -graphics.get_screen_height()
menu_configuration_features.menuYfeat.value = math.floor(stuff.menuData.y*graphics.get_screen_height())

menu_configuration_features.menuYfeat = menu.add_feature("max features", "autoaction_value_i", menu_configuration_features.cheesemenuparent.id, function(f)
	stuff.menuData:set_max_features(f.value)
end)
menu_configuration_features.menuYfeat.max = 25
menu_configuration_features.menuYfeat.mod = 1
menu_configuration_features.menuYfeat.min = 1
menu_configuration_features.menuYfeat.value = math.floor(11)

menu_configuration_features.menuYfeat = menu.add_feature("Menu width", "autoaction_value_i", menu_configuration_features.cheesemenuparent.id, function(f)
	stuff.menuData.width = f.value/graphics.get_screen_width()
end)
menu_configuration_features.menuYfeat.max = graphics.get_screen_width()
menu_configuration_features.menuYfeat.mod = 1
menu_configuration_features.menuYfeat.min = -graphics.get_screen_width()
menu_configuration_features.menuYfeat.value = math.floor(stuff.menuData.width*graphics.get_screen_width())

menu_configuration_features.featXfeat = menu.add_feature("Feature dimensions X", "autoaction_value_i", menu_configuration_features.cheesemenuparent.id, function(f)
	stuff.menuData.feature_scale.x = f.value/graphics.get_screen_width()
end)
menu_configuration_features.featXfeat.max = graphics.get_screen_width()
menu_configuration_features.featXfeat.mod = 1
menu_configuration_features.featXfeat.min = -graphics.get_screen_width()
menu_configuration_features.featXfeat.value = math.floor(stuff.menuData.feature_scale.x*graphics.get_screen_width())
menu_configuration_features.featYfeat = menu.add_feature("Feature dimensions Y", "autoaction_value_i", menu_configuration_features.cheesemenuparent.id, function(f)
	stuff.menuData.feature_scale.y = f.value/graphics.get_screen_height()
end)
menu_configuration_features.featYfeat.max = graphics.get_screen_height()
menu_configuration_features.featYfeat.mod = 1
menu_configuration_features.featYfeat.min = -graphics.get_screen_height()
menu_configuration_features.featYfeat.value = math.floor(stuff.menuData.feature_scale.y*graphics.get_screen_height())

menu_configuration_features.feature_offset = menu.add_feature("Feature spacing", "autoaction_value_i", menu_configuration_features.cheesemenuparent.id, function(f)
	stuff.menuData.feature_offset = f.value/graphics.get_screen_height()
end)
menu_configuration_features.feature_offset.max = graphics.get_screen_height()
menu_configuration_features.feature_offset.mod = 1
menu_configuration_features.feature_offset.min = -graphics.get_screen_height()
menu_configuration_features.feature_offset.value = math.floor(stuff.menuData.feature_offset*graphics.get_screen_height())

menu_configuration_features.headerfeat = menu.add_feature("Header", "autoaction_value_str", menu_configuration_features.cheesemenuparent.id, function(f)
	stuff.menuData.header = f.str_data[f.value + 1]
end)
menu_configuration_features.headerfeat:set_str_data(stuff.menuData.files.headers)

menu_configuration_features.backgroundparent = menu.add_feature("Background", "parent", menu_configuration_features.cheesemenuparent.id)

local backgroundfeat = menu.add_feature("Background", "autoaction_value_str", menu_configuration_features.backgroundparent.id, function(f)
	if f.str_data[f.value + 1] == "none" then
		stuff.menuData.background_sprite.sprite = nil
	else
		stuff.menuData.background_sprite.sprite = f.str_data[f.value + 1]
	end
end)
backgroundfeat:set_str_data({table.unpack(stuff.menuData.files.background), "none"})

menu.add_feature("Fit background to width", "action", menu_configuration_features.backgroundparent.id, function()
	stuff.menuData.background_sprite:fit_size_to_width()
end)

local backgroundoffsetx = menu.add_feature("Background pos X", "autoaction_value_i", menu_configuration_features.backgroundparent.id, function(f)
	if func.get_key(0x65):is_down() then
		local stat, num = input.get("num", "", 10, 3)
		stuff.menuData.background_sprite.offset.x = num/graphics.get_screen_width()
		f.value = num
	end
	stuff.menuData.background_sprite.offset.x = f.value/graphics.get_screen_width()
end)
backgroundoffsetx.max = graphics.get_screen_width()
backgroundoffsetx.mod = 1
backgroundoffsetx.min = -graphics.get_screen_width()
backgroundoffsetx.value = math.floor(stuff.menuData.background_sprite.offset.x*graphics.get_screen_width())

local backgroundoffsety = menu.add_feature("Background pos Y", "autoaction_value_i", menu_configuration_features.backgroundparent.id, function(f)
	if func.get_key(0x65):is_down() then
		local stat, num = input.get("num", "", 10, 3)
		stuff.menuData.background_sprite.offset.y = num/graphics.get_screen_height()
		f.value = num
	end
	stuff.menuData.background_sprite.offset.y = f.value/graphics.get_screen_height()
end)
backgroundoffsety.max = graphics.get_screen_height()
backgroundoffsety.mod = 1
backgroundoffsety.min = -graphics.get_screen_height()
backgroundoffsety.value = math.floor(stuff.menuData.background_sprite.offset.x*graphics.get_screen_height())

menu_configuration_features.backgroundsize = menu.add_feature("Background Size", "autoaction_value_f", menu_configuration_features.backgroundparent.id, function(f)
	stuff.menuData.background_sprite.size = f.value
end)

menu_configuration_features.backgroundsize.max = 1
menu_configuration_features.backgroundsize.mod = 0.01

menu_configuration_features.hotkeyparent = menu.add_feature("Hotkey notifications", "parent", menu_configuration_features.cheesemenuparent.id)

menu.add_feature("Toggle notification", "toggle", menu_configuration_features.hotkeyparent.id, function(f)
	stuff.hotkey_notifications.toggle = f.on
	gltw.write(stuff.hotkey_notifications, "hotkey notifications", stuff.path.hotkeys)
end).on = stuff.hotkey_notifications.toggle
menu.add_feature("Action notification", "toggle", menu_configuration_features.hotkeyparent.id, function(f)
	stuff.hotkey_notifications.action = f.on
	gltw.write(stuff.hotkey_notifications, "hotkey notifications", stuff.path.hotkeys)
end).on = stuff.hotkey_notifications.action



local colorParent = menu.add_feature("colors", "parent", menu_configuration_features.cheesemenuparent.id)
for k, v in pairs(stuff.menuData.color) do
	local vParent = menu.add_feature(k, "parent", colorParent.id)
	local red = menu.add_feature("red", "autoaction_value_i", vParent.id, function(f)
		stuff.menuData.color:set_color(k, f.value)
	end)
	red.max = 255
	if type(v) == "table" then
		red.value = v.r
	else
		red.value = func.convert_int_to_rgba(v, "r")
	end
	local green = menu.add_feature("green", "autoaction_value_i", vParent.id, function(f)
		stuff.menuData.color:set_color(k, nil, f.value)
	end)
	green.max = 255
	if type(v) == "table" then
		green.value = v.g
	else
		green.value = func.convert_int_to_rgba(v, "g")
	end
	local blue = menu.add_feature("blue", "autoaction_value_i", vParent.id, function(f)
		stuff.menuData.color:set_color(k, nil, nil, f.value)
	end)
	blue.max = 255
	if type(v) == "table" then
		blue.value = v.b
	else
		blue.value = func.convert_int_to_rgba(v, "b")
	end
	local alpha = menu.add_feature("alpha", "autoaction_value_i", vParent.id, function(f)
		stuff.menuData.color:set_color(k, nil, nil, nil, f.value)
	end)
	alpha.max = 255
	if type(v) == "table" then
		alpha.value = v.a
	else
		alpha.value = func.convert_int_to_rgba(v, "a")
	end
end

--changing menu functions to ui functions
menu.add_feature = func.add_feature
menu.add_player_feature = func.add_player_feature
menu.delete_feature = func.delete_feature
menu.delete_player_feature = func.delete_player_feature
menu.get_player_feature = func.get_player_feature
cheeseUIdata = stuff.menuData
--
func.set_player_feat_parent("Online Players", 0)
