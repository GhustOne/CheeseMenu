--Made by GhostOne

--[[
    ,o888888o.    8 8888        8 8 8888888888   8 8888888888      d888888o.   8 8888888888
   8888     `88.  8 8888        8 8 8888         8 8888          .`8888:' `88. 8 8888
,8 8888       `8. 8 8888        8 8 8888         8 8888          8.`8888.   Y8 8 8888
88 8888           8 8888        8 8 8888         8 8888          `8.`8888.     8 8888
88 8888           8 8888        8 8 888888888888 8 888888888888   `8.`8888.    8 888888888888
88 8888           8 8888        8 8 8888         8 8888            `8.`8888.   8 8888
88 8888           8 8888888888888 8 8888         8 8888             `8.`8888.  8 8888
`8 8888       .8' 8 8888        8 8 8888         8 8888         8b   `8.`8888. 8 8888
   8888     ,88'  8 8888        8 8 8888         8 8888         `8b.  ;8.`8888 8 8888
    `8888888P'    8 8888        8 8 888888888888 8 888888888888  `Y8888P ,88P' 8 888888888888
          .         .
         ,8.       ,8.          8 8888888888   b.             8 8 8888      88
        ,888.     ,888.         8 8888         888o.          8 8 8888      88
       .`8888.   .`8888.        8 8888         Y88888o.       8 8 8888      88
      ,8.`8888. ,8.`8888.       8 8888         .`Y888888o.    8 8 8888      88
     ,8'8.`8888,8^8.`8888.      8 888888888888 8o. `Y888888o. 8 8 8888      88
    ,8' `8.`8888' `8.`8888.     8 8888         8`Y8o. `Y88888o8 8 8888      88
   ,8'   `8.`88'   `8.`8888.    8 8888         8   `Y8o. `Y8888 8 8888      88
  ,8'     `8.`'     `8.`8888.   8 8888         8      `Y8o. `Y8 ` 8888     ,8P
 ,8'       `8        `8.`8888.  8 8888         8         `Y8o.`   8888   ,d8P
,8'         `         `8.`8888. 8 888888888888 8            `Yo    `Y88888P'
]]

local version = "1.6.9.1"
local loadCurrentMenu

-- Version check
menu.create_thread(function()
	local vercheckKeys = {ctrl = MenuKey(), space = MenuKey(), enter = MenuKey(), rshift = MenuKey()}
	vercheckKeys.ctrl:push_vk(0x11); vercheckKeys.space:push_vk(0x20); vercheckKeys.enter:push_vk(0x0D); vercheckKeys.rshift:push_vk(0xA1)

	local responseCode, githubVer = web.get("https://raw.githubusercontent.com/GhustOne/CheeseMenu/main/VERSION.txt")
	if responseCode == 200 then
		githubVer = githubVer:gsub("[\r\n]", "")
		if githubVer ~= version then
			local strings = {
				version_compare = "\nCurrent Version:"..version.."\nLatest Version:"..githubVer,
				version_compare_x_offset = v2(-scriptdraw.get_text_size("\nCurrent Version:"..version.."\nLatest Version:"..githubVer, 1).x/graphics.get_screen_width(), 0),
				new_ver_x_offset = v2(-scriptdraw.get_text_size("New version available. Press CTRL or SPACE to skip or press ENTER or RIGHT SHIFT to update.", 1).x/graphics.get_screen_width(), 0),
			}
			strings.changelog_rc, strings.changelog = web.get("https://raw.githubusercontent.com/GhustOne/CheeseMenu/main/CHANGELOG.txt")
			if strings.changelog_rc == 200 then
				strings.changelog = "\n\n\nChangelog:\n"..strings.changelog
			else
				strings.changelog = ""
			end
			strings.changelog_x_offset = v2(-scriptdraw.get_text_size(strings.changelog, 1).x/graphics.get_screen_width(), 0)
			local stringV2size = v2(2, 2)
			local text_size = graphics.get_screen_width()*graphics.get_screen_height()/3686400*0.5+0.5
			while true do
				scriptdraw.draw_text("New version available. Press CTRL or SPACE to skip or press ENTER or RIGHT SHIFT to update.", strings.new_ver_x_offset, stringV2size, text_size, 0xFF0CB4F4, 2)
				scriptdraw.draw_text(strings.version_compare, strings.version_compare_x_offset, stringV2size, text_size, 0xFF0CB4F4, 2)
				scriptdraw.draw_text(strings.changelog, strings.changelog_x_offset, stringV2size, text_size, 0xFF0CB4F4, 2)
				if vercheckKeys.ctrl:is_down() or vercheckKeys.space:is_down() then
					loadCurrentMenu()
					break
				elseif vercheckKeys.enter:is_down() or vercheckKeys.rshift:is_down() then
					local responseCode, autoupdater = web.get([[https://raw.githubusercontent.com/GhustOne/CheeseMenu/main/CMAutoUpdater.lua]])
					if responseCode == 200 then
						autoupdater = load(autoupdater)
						menu.create_thread(function()
							menu.notify("Update started, please wait...", "Cheese Menu")
							local status = autoupdater()
							if status then
								if type(status) == "string" then
									menu.notify("Updating local files failed, one or more of the files could not be opened.\nThere is a high chance the files got corrupted, please redownload the menu.", "Cheese Menu", 5, 0x0000FF)
								else
									menu.notify("Update successful", "Cheese Menu", 4, 0x00FF00)
									dofile(utils.get_appdata_path("PopstarDevs", "2Take1Menu").."\\scripts\\cheesemenu.lua")
								end
							else
								menu.notify("Download for updated files failed, current files have not been replaced.", "Cheese Menu", 5, 0x0000FF)
							end
						end, nil)
						break
					else
						menu.notify("Getting Updater failed. Check your connection and try downloading manually.", "Cheese Menu", 5, 0x0000FF)
					end
				end
				system.wait(0)
			end
		else
			loadCurrentMenu()
		end
	end
end, nil)

local features
local currentMenu
local func
local stuff
function loadCurrentMenu()
	features = {OnlinePlayers = {}}
	currentMenu = features
	func = {}
	stuff = {
		pid = -1,
		player_info = {
			{"Player ID", "0"},
			{"God", "false"},
			{"Proofs (God)", "false"},
			{"Vehicle God", "false"},
			{"Flagged as Modder", "false"},
			{"Host", "false"},
			{"Wanted", "0"},
			{"Health", "327/327"},
			{"Armor", "50"},
			{"IP", "0.0.0.0"},
			{"SCID", "133769420"},
			{"Host Token", "0xdeadbeef"},
			{"Host Priority", "0"},
			max_health = "/327",
			name = "cheesemenu"
		},
		proofs = {
			bulletProof = native.ByteBuffer8(),
			fireProof = native.ByteBuffer8(),
			explosionProof = native.ByteBuffer8(),
			collisionProof = native.ByteBuffer8(),
			meleeProof = native.ByteBuffer8(),
			steamProof = native.ByteBuffer8(),
			p7 = native.ByteBuffer8(),
			drownProof = native.ByteBuffer8(),
		},
		scroll = 1,
		scrollHiddenOffset = 0,
		drawHiddenOffset = 0,
		previousMenus = {},
		threads = {},
		feature_by_id = {},
		player_feature_by_id = {},
		path = {
			scripts = utils.get_appdata_path("PopstarDevs", "2Take1Menu").."\\scripts\\"
		},
		hotkeys = {},
		hotkeys_to_vk = {},
		char_codes = {
			["ENTER"] = 0x0D,
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
		controls = {
			left = "LEFTARROW",
			up = "UPARROW",
			right =  "RIGHTARROW",
			down = "DOWNARROW",
			select = "ENTER",
			back = "BACKSPACE",
			open = "F4",
			setHotkey = "F11"
		},
		vkcontrols = {
			left = 0x25,
			up = 0x26,
			right = 0x27,
			down = 0x28,
			select = 0x0D,
			back = 0x08,
			open = 0x73,
			setHotkey = 0x7A
		},
		drawScroll = 0,
		maxDrawScroll = 0,
		menuData = {
			menuToggle = false,
			chatBoxOpen = false,
			x = 0.5,
			y = 0.44652777777,
			width = 0.2,
			height = 0.305,
			border = 0.0013888,
			footer = {
				padding = 0.0078125,
				footer_size = 0.019444444,
				draw_footer = true,
				footer_pos_related_to_background = false,
				footer_text = "Made by GhostOne",
			},
			side_window = {
				on = true,
				offset = {x = 0, y = 0},
				spacing = 0.0547222,
				width = 0.3,
				padding = 0.01
			},
			header = "cheese_menu",
			feature_offset = 0.025,
			feature_scale = {x = 0.2, y = 0.025},
			color = {},
			files = {},
			background_sprite = {
				sprite = nil,
				size = 1,
				loaded_sprites = {},
				offset = {x = 0, y = 0}
			},
			max_features = 12,
			set_max_features = function(self, int)
				int = math.floor(int+0.5)
				self.height = int * self.feature_offset
				self.max_features = int
			end
		},
		disable_all_controls = function()
			while true do
				for i = 0, 360 do
					controls.disable_control_action(0, i, true)
				end
				system.wait(0)
			end
		end
	}

	stuff.menuData.color = {
		background = {r = 0, g = 0, b = 0, a = 0},
		sprite = 0xE6FFFFFF,
		feature = {r = 255, g = 160, b = 0, a = 170},
		feature_selected = {r = 0, g = 0, b = 0, a = 200},
		text_selected = {r = 255, g = 200, b = 0, a = 180},
		text = {r = 0, g = 0, b = 0, a = 180},
		border = {r = 0, g = 0, b = 0, a = 180},
		footer = {r = 255, g = 160, b = 0, a = 170},
		footer_text = {r = 0, g = 0, b = 0, a = 180},
		notifications = {r = 255, g = 200, b = 0, a = 255},
		side_window = {r = 0, g = 0, b = 0, a = 150},
		side_window_text = {r = 255, g = 255, b = 255, a = 220}
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

	function func.convert_int_ip(ip)
		local ipTable = {}
		ipTable[1] = ip >> 24 & 255
		ipTable[2] = ip >> 16 & 255
		ipTable[3] = ip >> 8 & 255
		ipTable[4] = ip & 255
		
		return table.concat(ipTable, ".")
	end

	stuff.input = require("cheesemenu.libs.Get Input")
	require("cheesemenu.libs.GLTW")
	local cheeseUtils = require("cheesemenu.libs.CheeseUtilities")
	assert(gltw, "GLTW is not found, please reinstall the menu.")


	gltw.read("controls", stuff.path.cheesemenu, stuff.controls, true)
	for k, v in pairs(stuff.controls) do
		stuff.vkcontrols[k] = stuff.char_codes[v]
	end

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
			stuff.menuData.chatBoxOpen = true
			local status, gottenInput = stuff.input.get_input(title, default, len, Type)

			stuff.menuData.menuToggle = originalmenuToggle
			stuff.menuData.chatBoxOpen = false
			return status, gottenInput
		end
	end

	-- Credit to kektram for these functions
	do
		local _ENV <const> = {
			getmetatable = debug.getmetatable
		}
		function stuff.rawset(Table, index, value) -- Matches performance of normal rawset.
			local metatable <const> = getmetatable(Table)
			local __newindex
			if metatable then
				__newindex = metatable.__newindex
				metatable.__newindex = nil
			end
			Table[index] = value
			if __newindex then
				metatable.__newindex = __newindex
			end
			return Table
		end
	end
	do
		local _ENV <const> = {
			getmetatable = debug.getmetatable
		}
		function stuff.rawget(Table, index, value) -- Matches performance of normal rawget.
			local metatable <const> = getmetatable(Table)
			local __index
			if metatable then
				__index = metatable.__index
				metatable.__index = nil
			end
			local value <const> = Table[index]
			if __index then
				metatable.__index = __index
			end
			return value
		end
	end
	--

	stuff.playerSpecialValues = {value = true, min = true, max = true, mod = true, on = true, real_value = true, real_max = true, real_min = true, real_mod = true, real_on = true}

	stuff.featMetaTable = {
		__index = function(t, k)
			if k == "is_highlighted" then
				return t == currentMenu[stuff.scroll + stuff.scrollHiddenOffset]
			elseif k == "value" or k == "min" or k == "mod" or k == "max" or k == "str_data" or k == "type" or k == "id" or k == "on" or k == "hidden" or k == "data" then
				if t.playerFeat and k ~= "str_data" and k ~= "type" and k ~= "id" and k ~= "hidden" and k ~= "data" then
					return stuff.rawget(t, "table_"..k)
				else
					return stuff.rawget(t, "real_"..k)
				end
			elseif k == "children" and t.type == 2048 then
				return t:get_children()
			else
				return stuff.rawget(t, k)
			end
		end,

		__newindex = function(t, k, v)
			assert(k ~= "id" and k ~= "children" and k ~= "type" and k ~= "str_data" and k ~= "is_highlighted", "'"..k.."' is read only")
			if k == "on" and type(v) == "boolean" then
				stuff.rawset(t, "real_on", v)
				if t.feats then
					for i, e in pairs(t.feats) do
						if player.is_player_valid(i) then
							t.feats[i].on = v
						end
					end
				else
					if v then
						t:activate_feat_func()
					end
				end
			elseif k == "value" or k == "min" or k == "mod" or k == "max" then
				if k ~= "value" and stuff.type_id.id_to_name[t.type]:match("value_str") then
					error("max, min and mod are readonly for value_str features")
				end
				assert(stuff.type_id.id_to_name[t.type]:match("value_[if]") or stuff.type_id.id_to_name[t.type]:match("value_str"), "feat type not supported")
				assert(tonumber(v), "tried to set "..k.." property to a non-number value")
				v = tonumber(v)

				if k:match("value") then
					if t.real_min then
						if v < t.real_min then
							v = t.real_min
						end
					else
						if v < 0 then
							v = 0
						end
					end
					if t.real_max then
						if v > t.real_max then
							v = t.real_max
						end
					elseif t.real_str_data then
						if v+1 > #t.real_str_data then
							v = #t.real_str_data-1
						end
					end
				end

				if stuff.type_id.id_to_name[t.type]:match("_i") or stuff.type_id.id_to_name[t.type]:match("value_str") then
					v = math.floor(v)

					stuff.rawset(t, "real_"..k, v)
					if t["table_"..k] then
						for i, e in pairs(t["table_"..k]) do
							t["table_"..k][i] = v
						end
					end
				elseif stuff.type_id.id_to_name[t.type]:match("_f") then
					stuff.rawset(t, "real_"..k, v)

					if t["table_"..k] then
						for i, e in pairs(t["table_"..k]) do
							t["table_"..k][i] = v
						end
					end
				end
			elseif k == "hidden" then
				assert(type(v) == "boolean", "hidden only accepts booleans")
				t.real_hidden = v
				if v then
					func.deleted_or_hidden_parent_check(t)
				end
			elseif k == "data" then
				stuff.rawset(t, "real_data", v)
				if t.feats then
					for i, e in pairs(t.feats) do
						t.feats[i].real_data = v
					end
				end
			else
				stuff.rawset(t, k, v)
			end
		end
	}

	stuff.playerfeatMetaTable = {
		__index = function(t, k)
			if k == "is_highlighted" then
				return t == currentMenu[stuff.scroll + stuff.scrollHiddenOffset]
			elseif k == "str_data" or k == "type" or k == "id" or k == "data" or k == "hidden" then
				return stuff.rawget(t, "real_"..k)
			elseif stuff.playerSpecialValues[k] then
				if t["table_"..k:gsub("real_", "")] then
					return t["table_"..k:gsub("real_", "")][t.pid]
				end
			else
				return stuff.rawget(t, k)
			end
		end,

		__newindex = function(t, k, v)
			assert(k ~= "id" and k ~= "children" and k ~= "type" and k ~= "str_data" and k ~= "is_highlighted", "'"..k.."' is read only")
			if (k == "on" or k == "real_on") and type(v) == "boolean" then
				t["table_on"][t.pid] = v
				if v then
					t:activate_feat_func()
				end
			elseif stuff.playerSpecialValues[k] then
				k = k:gsub("real_", "")
				if k ~= "value" and stuff.type_id.id_to_name[t.type]:match("value_str") then
					error("max, min and mod are readonly for value_str features")
				end
				assert(stuff.type_id.id_to_name[t.type]:match("value_[if]") or stuff.type_id.id_to_name[t.type]:match("value_str"), "feat type not supported")
				assert(tonumber(v), "tried to set "..k.." property to a non-number value")
				v = tonumber(v)

				if t.real_min then
					if v < t.real_min then
						v = t.real_min
					end
				else
					if v < 0 then
						v = 0
					end
				end
				if t.real_max then
					if v > t.real_max then
						v = t.real_max
					end
				elseif t.real_str_data then
					if v+1 > #t.real_str_data then
						v = #t.real_str_data-1
					end
				end

				if stuff.type_id.id_to_name[t.type]:match("_i") or stuff.type_id.id_to_name[t.type]:match("value_str") then
					v = math.floor(v)
					t["table_"..k][t.pid] = v
				elseif stuff.type_id.id_to_name[t.type]:match("_f") then
					t["table_"..k][t.pid] = v
				end
			elseif k == "data" then
				t.real_data = v
			else
				stuff.rawset(t, k, v)
			end
		end
	}

	-- featMethods

	-- dogshit dont use
	--[[ stuff.set_val = function(self, valueType, val, dont_set_all)
		assert(stuff.type_id.id_to_name[self.type]:match("value_[if]") or stuff.type_id.id_to_name[self.type]:match("value_str"), "feat type not supported")
		assert(tonumber(val), "tried to set "..valueType.." to a non-number value")
		if stuff.type_id.id_to_name[self.type]:match("value_i") then
			val = tonumber(math.floor(val))
		else
			val = tonumber(val)
		end

		if valueType == "value" then
			if self.real_min then
				if val < self.real_min then
					val = self.real_min
				end
			else
				if val < 0 then
					val = 0
				end
			end
			if self.real_max then
				if val > self.real_max then
					val = self.real_max
				end
			elseif self.real_str_data then
				if val+1 > #self.real_str_data then
					val = #self.real_str_data-1
				end
			end
		end

		self[valueType] = val
		if self["table_"..valueType] and not dont_set_all then
			for i = 0, 31 do
				self["table_"..valueType][i] = val
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
	end ]]

	stuff.get_str_data = function(self)
		assert(stuff.type_id.id_to_name[self.type]:match("value_str"), "used get_str_data on a feature that isn't value_str")
		return self.str_data
	end

	stuff.set_str_data = function(self, stringTable)
		assert(type(stringTable) == "table", "tried to set str_data property to a non-table value")
		local numberedTable
		for k, v in pairs(stringTable) do
			if type(k) ~= "number" then
				numberedTable = {}
				for k, v in pairs(stringTable) do
					numberedTable[#numberedTable + 1] = v
				end
				break
			end
		end
		self.real_str_data = numberedTable or stringTable
		if self.real_value+1 > #self.real_str_data then
			self.real_value = #self.real_str_data-1
		end
		if self.feats then
			for k, v in pairs(self.table_value) do
				if v+1 > #self.real_str_data then
					self.table_value[k] = #self.real_str_data-1
				end
			end
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
		for k, v in ipairs(self) do
			if type(k) == "number" then
				children[k] = v
			end
		end
		return children
	end

	-- function callback ~Thanks to Proddy for telling me that doing function() every time creates a new one and providing examples on how to use menu.create_thread with the function below
	function stuff.feature_callback(self)
		local pidordata = self.pid or self.data
		local continue = self:func(pidordata, self.data)
		while continue == HANDLER_CONTINUE and self.real_on do
			system.wait(0)
			continue = self:func(pidordata, self.data)
		end
	end

	function stuff.highlight_callback(self)
		local pidordata = self.pid or self.data
		local continue = self:hl_func(pidordata, self.data)
		while continue == HANDLER_CONTINUE and self.real_on do
			system.wait(0)
			continue = self:hl_func(pidordata, self.data)
		end
	end

	stuff.activate_feat_func = function(self)
		if not (self.thread) then
			self.thread = 0
		end
		if self.func and menu.has_thread_finished(self.thread) then
			self.thread = menu.create_thread(stuff.feature_callback, self)
		end
	end

	-- highlight callback
	stuff.activate_hl_func = function(self)
		if self.hl_func then
			if not self.hl_thread then
				self.hl_thread = 0
			end
			if menu.has_thread_finished(self.hl_thread) then
				self.hl_thread = menu.create_thread(stuff.highlight_callback, self)
			end
		end
	end
	--

	stuff.select = function(self)
		local parent_of_feat_wanted = stuff.feature_by_id[self.parent_id] or features

		if not (parent_of_feat_wanted == currentMenu) then
			stuff.previousMenus[#stuff.previousMenus + 1] = {menu = currentMenu, scroll = stuff.scroll, drawScroll = stuff.drawScroll, scrollHiddenOffset = stuff.scrollHiddenOffset}
			currentMenu = parent_of_feat_wanted
		end

		if not self.hidden then
			local hiddenOffset = 0
			for k, v in ipairs(parent_of_feat_wanted) do
				if type(k) == "number" then 
					if v.hidden and not (k > self.index) then
						hiddenOffset = hiddenOffset + 1
					end
				end
			end
			stuff.scroll = self.index - hiddenOffset
			stuff.drawScroll = (stuff.maxDrawScroll >= self.index) and self.index-1 or stuff.maxDrawScroll
		end

		stuff.scrollHiddenOffset = 0
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
	function func.add_feature(nameOfFeat, TypeOfFeat, parentOfFeat, functionCallback, highlightCallback, playerFeat)
		assert((type(nameOfFeat) == "string"), "invalid name in add_feature")
		assert((type(TypeOfFeat) == "string") and stuff.type_id.name_to_id[TypeOfFeat], "invalid type in add_feature")
		assert(((type(parentOfFeat) == "string") or (type(parentOfFeat) == "number")) or not parentOfFeat, "invalid parent id in add_feature")
		assert((type(functionCallback) == "function") or not functionCallback, "invalid function in add_feature")
		if not parentOfFeat then
			parentOfFeat = 0
		end
		TypeOfFeat = TypeOfFeat:gsub("slider", "value_f")
		local currentParent = features
		if playerFeat then
			currentParent = features["OnlinePlayers"]
		end

		local hierarchy_key
		if parentOfFeat ~= 0 and parentOfFeat then
			if playerFeat then
				currentParent = stuff.player_feature_by_id[parentOfFeat]
			else
				currentParent = stuff.feature_by_id[parentOfFeat]
			end
			if currentParent then
				assert(currentParent.type == 2048, "parent is not a parent feature")
			else
				error("parent is not valid "..((stuff.player_feature_by_id[parentOfFeat] and not playerFeat) and "using player feature as parent for a local feature" or (stuff.feature_by_id[parentOfFeat] and playerFeat and "using local parent for player feature")))
			end
		end
		if currentParent.hierarchy_key then
			hierarchy_key = currentParent.hierarchy_key.."."..nameOfFeat:gsub("[ %.]", "_")
		else
			hierarchy_key = nameOfFeat:gsub("[ %.]", "_")
		end

		currentParent[#currentParent + 1] = {name = nameOfFeat, real_type = stuff.type_id.name_to_id[TypeOfFeat], real_id = 0, parent = {id = currentParent.id or 0}, parent_id = currentParent.id or 0, playerFeat = playerFeat, index = #currentParent + 1}
		currentParent[#currentParent].activate_feat_func = stuff.activate_feat_func
		currentParent[#currentParent].activate_hl_func = stuff.activate_hl_func
		currentParent[#currentParent].set_str_data = stuff.set_str_data
		currentParent[#currentParent].toggle = stuff.toggle
		currentParent[#currentParent].get_children = stuff.get_children
		currentParent[#currentParent].set_value = stuff.set_value
		currentParent[#currentParent].set_min = stuff.set_min
		currentParent[#currentParent].set_mod = stuff.set_mod
		currentParent[#currentParent].set_max = stuff.set_max
		currentParent[#currentParent].get_str_data = stuff.get_str_data
		currentParent[#currentParent].select = stuff.select
		setmetatable(currentParent[#currentParent], stuff.featMetaTable)
		currentParent[#currentParent].thread = 0
		if stuff.type_id.id_to_name[currentParent[#currentParent].real_type]:match("toggle") then
			if playerFeat then
				currentParent[#currentParent].table_on = {}
				for i = 0, 31 do
					currentParent[#currentParent].table_on[i] = false
				end
			end
			currentParent[#currentParent].on = false
		end
		if TypeOfFeat:match(".*value_str.*") then
			if playerFeat then
				currentParent[#currentParent].table_value = {}
				for i = 0, 31 do
					currentParent[#currentParent].table_value[i] = 0
				end
			end
			currentParent[#currentParent].value = 0
			currentParent[#currentParent].real_str_data = {}
		elseif TypeOfFeat:match(".*value") then
			if playerFeat then
				currentParent[#currentParent].table_value = {}
				currentParent[#currentParent].table_max = {}
				currentParent[#currentParent].table_min = {}
				currentParent[#currentParent].table_mod = {}
				for i = 0, 31 do
					currentParent[#currentParent].table_value[i] = 0
					currentParent[#currentParent].table_max[i] = 0
					currentParent[#currentParent].table_min[i] = 0
					currentParent[#currentParent].table_mod[i] = 1
				end
			end
			currentParent[#currentParent].value = 0
			currentParent[#currentParent].max = 0
			currentParent[#currentParent].min = 0
			currentParent[#currentParent].mod = 1
		end
		currentParent[#currentParent].hidden = false
		currentParent[#currentParent]["func"] = functionCallback
		currentParent[#currentParent]["hl_func"] = highlightCallback
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
		if playerFeat then
			stuff.player_feature_by_id[#stuff.player_feature_by_id+1] = currentParent[#currentParent]
			currentParent[#currentParent].real_id = #stuff.player_feature_by_id
		else
			stuff.feature_by_id[#stuff.feature_by_id+1] = currentParent[#currentParent]
			currentParent[#currentParent].real_id = #stuff.feature_by_id
		end
		return currentParent[#currentParent]
	end

	--player feature functions

	-- if you set a toggle player feature to on it'll enable for any valid players/joining players but if a player leaves functions like player.get_player_name will return nil before the feature is turned off
	function func.add_player_feature(nameOfFeat, TypeOfFeat, parentOfFeat, functionCallback, highlightCallback)
		parentOfFeat = parentOfFeat or 0
		assert(stuff.PlayerParent, "you need to use set_player_feat_parent before adding player features")
		local pfeat = func.add_feature(nameOfFeat, TypeOfFeat, parentOfFeat, functionCallback, highlightCallback, true)
		pfeat.feats = {}

		if parentOfFeat == 0 then
			for k = 0, 31 do
				stuff.playerIds[k][#stuff.playerIds[k]+1] = {}
				local currentFeat = stuff.playerIds[k][#stuff.playerIds[k]]
				func.add_to_table(pfeat, currentFeat, k, nil, true)
				stuff.feature_by_id[#stuff.feature_by_id+1] = currentFeat
				currentFeat.ps_id = #stuff.feature_by_id
				currentFeat.ps_parent_id = stuff.playerIds[k].id
				currentFeat.pid = k
				pfeat.feats[k] = currentFeat
			end
		else
			local playerParent = stuff.player_feature_by_id[parentOfFeat]
			if playerParent then
				for k = 0, 31 do
					playerParent.feats[k][#playerParent.feats[k]+1] = {}
					local currentFeat = playerParent.feats[k][#playerParent.feats[k]]

					func.add_to_table(pfeat, currentFeat, k, nil, true)
					stuff.feature_by_id[#stuff.feature_by_id+1] = currentFeat
					currentFeat.ps_id = #stuff.feature_by_id
					currentFeat.ps_parent_id = playerParent.feats[k].ps_id
					currentFeat.pid = k
					pfeat.feats[k] = currentFeat
				end
			end
		end

		return pfeat
	end

	function func.add_to_table(getTable, addToTable, playerid, override, setmeta)
		local isPlayerFeatValues
		for k, v in pairs(getTable) do
			if tostring(k):match("table_") or stuff.playerSpecialValues[k] then
				isPlayerFeatValues = true
			elseif type(v) == "table" then
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
				setmetatable(addToTable[k], stuff.playerfeatMetaTable)
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
		if setmeta or isPlayerFeatValues then
			addToTable.table_value = getTable.table_value
			addToTable.table_min = getTable.table_min
			addToTable.table_max = getTable.table_max
			addToTable.table_mod = getTable.table_mod
			addToTable.table_on = getTable.table_on
			for i, e in pairs(stuff.playerSpecialValues) do
				if addToTable[i] then
					stuff.rawset(addToTable, i, nil)
				end
			end
			setmetatable(addToTable, stuff.playerfeatMetaTable)
		end
	end

	function func.set_player_feat_parent(nameOfFeat, parentOfFeat, functionToDo)
		stuff.PlayerParent = func.add_feature(nameOfFeat, "parent", parentOfFeat, functionToDo)
		stuff.playerIds = {}
			for i = 0, 31 do
				stuff.playerIds[i] = func.add_feature(tostring(player.get_player_name(i)), "parent", stuff.PlayerParent.id)
				stuff.playerIds[i].pid = i
				stuff.playerIds[i].hidden = not player.is_player_valid(i)
			end

		event.add_event_listener("player_join", function(listener)
			system.wait(100)
			stuff.playerIds[listener.player].hidden = false
			stuff.playerIds[listener.player].name = player.get_player_name(listener.player)
			func.reset_player_submenu(listener.player)
		end)
		event.add_event_listener("player_leave", function(listener)
			func.reset_player_submenu(listener.player)
			stuff.playerIds[listener.player].hidden = true
			stuff.playerIds[listener.player].name = "nil"
		end)
		return stuff.PlayerParent
	end

	function func.reset_player_submenu(pid, currentParent)
		local currentParent = currentParent or features.OnlinePlayers
		for k, v in pairs(currentParent) do
			if type(currentParent[k]) == "table" then
				local feat_type = stuff.type_id.id_to_name[currentParent[k].type]
				if feat_type then
					if feat_type:match("value_") then
						currentParent[k].table_value[pid] = currentParent[k].real_value
						if feat_type:match("value_[if]") then
							currentParent[k].table_min[pid] = currentParent[k].real_min
							currentParent[k].table_max[pid] = currentParent[k].real_max
							currentParent[k].table_mod[pid] = currentParent[k].real_mod
						end
					end
					if feat_type:match("toggle") then
						if player.is_player_valid(pid) then
							currentParent[k].feats[pid].on = currentParent[k].real_on
						else
							currentParent[k].feats[pid].on = false
							currentParent[k].table_on[pid] = false
						end
					end
					if feat_type == "parent" then
						func.reset_player_submenu(pid, currentParent[k])
					end
				end
			end
		end
	end
	--end of player feature functions

	function func.deleted_or_hidden_parent_check(parent, check_hidden_only)
		if next(stuff.previousMenus) then
			local parentBeforeDHparent = false
			if parent ~= currentMenu then
				for k, v in ipairs(stuff.previousMenus) do
					if parentBeforeDHparent then
						stuff.previousMenus[k] = nil
					else
						if (v.menu == parent and not check_hidden_only) or (v.menu.hidden and check_hidden_only) then
							parentBeforeDHparent = true
							currentMenu = stuff.previousMenus[k-1].menu
							stuff.scroll = stuff.previousMenus[k-1].scroll
							stuff.drawScroll = stuff.previousMenus[k-1].drawScroll
							stuff.scrollHiddenOffset = stuff.previousMenus[k-1].scrollHiddenOffset
							stuff.previousMenus[k-1] = nil
							stuff.previousMenus[k] = nil
						end
					end
				end
			elseif not check_hidden_only then
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
		if feat then
			if feat[2] and not feat.name then
				return feat, true
			else
				return feat[1]
			end
		end
	end

	function func.get_feature(id)
		assert(type(id) == "number" and id ~= 0, "invalid id in get_feature")
		return stuff.feature_by_id[id]
	end

	function func.delete_feature(id, bool_ps)
		if type(id) == "table" then
			id = id.id
		end

		local feat = stuff.feature_by_id[id]

		if feat.thread then
			if not menu.has_thread_finished(feat.thread) then
				menu.delete_thread(feat.thread)
			end
		end

		local parent
		if feat.parent_id ~= 0 or bool_ps then
			parent = bool_ps and stuff.feature_by_id[feat.ps_parent_id] or stuff.feature_by_id[feat.parent_id]
		else
			parent = features
		end

		if feat.type == stuff.type_id.name_to_id["parent"] then
			func.deleted_or_hidden_parent_check(feat)
		end

		local index = feat.index
		table.remove(parent, tonumber(feat.index))

		for i = index, #parent do
			parent[i].index = i
		end

		return true
	end

	function func.delete_player_feature(id)
		if type(id) == "table" then
			id = id.id
		end


		local feat = stuff.player_feature_by_id[id]
		local parent
		if feat.parent_id ~= 0 then
			parent = stuff.player_feature_by_id[feat.parent_id]
		else
			parent = features["OnlinePlayers"]
		end

		for k, v in pairs(feat.feats) do
			func.delete_feature(v.ps_id, true)
		end

		local index = feat.index
		table.remove(parent, tonumber(index))
		for i = index, #parent do
			parent[i].index = i
			for pid = 0, 31 do
				parent[i].feats[pid].index = i
			end
		end
	end

	function func.get_player_feature(id)
		assert(type(id) == "number" and id ~= 0, "invalid id in get_player_feature")
		return stuff.player_feature_by_id[id]
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

	stuff.image_ext = {"gif", "bmp", "jpg", "jpeg", "png"}
	stuff.header_ids = {}
	function func.load_sprite(name, path, id_table)
		path = path or stuff.path.header
		id_table = id_table or stuff.header_ids
		name = tostring(name)
		assert(name, "invalid name")

		name = name:gsub("%.[a-z]+$", "")

		if not id_table[name] then
			if utils.dir_exists(path..name) then
				local path = path..name.."\\"
				local images

				for _, v in pairs(stuff.image_ext) do
					images = utils.get_all_files_in_directory(path, v)
					if images[1] then break end
				end
				if not images[1] then
					menu.notify("No frames found.", "Cheese Menu", 5, 0x0000FF)
					return
				end

				id_table[name] = {}
				for i, e in pairs(images) do
					id_table[name][i] = {}
					id_table[name][i].sprite = scriptdraw.register_sprite(path..e)
					id_table[name][i].delay = e:match("%d+_(%d+)")
				end

				id_table[name].constant_delay = utils.get_all_files_in_directory(path, "txt")[1]
				if not id_table[name].constant_delay then
					for k, v in pairs(images) do
						if not v:match("%d+_(%d+)") then
							menu.notify("FPS file not found and frames are not in format, create a txt file with the framerate of the gif.\nExample: '25 fps.txt'", "Cheese Menu", 5, 0x0000FF)
							break
						end
					end
				else
					id_table[name].constant_delay = math.floor(1000 / tonumber(id_table[name].constant_delay:match("(%d*%.*%d+)%s+fps")))
				end

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

	stuff.drawFeatParams = {
		rectPos = v2(stuff.menuData.x, stuff.menuData.y - stuff.menuData.feature_offset/2 + stuff.menuData.border),
		textOffset = v2(-(stuff.menuData.feature_scale.x/2-0.003125), -0.005859375),
		colorText = stuff.menuData.color.text,
		colorFeature = stuff.menuData.color.feature,
		textSize = 0,
		featV2_pos = v2(),
		featV2_size = v2(),
	}
	function func.draw_feat(k, v, offset, hiddenOffset, textSize)
		local stringtype = stuff.type_id.id_to_name[v.type]

		stuff.drawFeatParams.rectPos.x = stuff.menuData.x
		stuff.drawFeatParams.rectPos.y = stuff.menuData.y - stuff.menuData.feature_offset/2 + stuff.menuData.border
		stuff.drawFeatParams.textOffset.x = -(stuff.menuData.feature_scale.x/2-0.003125)
		stuff.drawFeatParams.colorText = stuff.menuData.color.text
		stuff.drawFeatParams.colorFeature = stuff.menuData.color.feature
		stuff.drawFeatParams.textSize = textSize

		offset = offset or 0
		local center = v.center or 0
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
			scriptdraw.draw_rect(
				cheeseUtils.memoize.v2(stuff.drawFeatParams.rectPos.x*2-1, (stuff.drawFeatParams.rectPos.y + (stuff.menuData.feature_offset * k))*-2+1),
				cheeseUtils.memoize.v2(stuff.menuData.feature_scale.x*2, stuff.menuData.feature_scale.y*2),
				func.convert_rgba_to_int(stuff.drawFeatParams.colorFeature.r, stuff.drawFeatParams.colorFeature.g, stuff.drawFeatParams.colorFeature.b, stuff.drawFeatParams.colorFeature.a)
			)
		end
		if v.type == stuff.type_id.name_to_id["parent"] then
			
			scriptdraw.draw_text(
				v["name"],
				cheeseUtils.memoize.v2((stuff.drawFeatParams.rectPos.x + stuff.drawFeatParams.textOffset.x)*2-1, (stuff.drawFeatParams.rectPos.y + stuff.drawFeatParams.textOffset.y + (stuff.menuData.feature_offset * k))*-2+1),
				cheeseUtils.memoize.v2(10, 10),
				stuff.drawFeatParams.textSize,
				func.convert_rgba_to_int(stuff.drawFeatParams.colorText.r, stuff.drawFeatParams.colorText.g, stuff.drawFeatParams.colorText.b, stuff.drawFeatParams.colorText.a),
				0, 0
			)
			
			scriptdraw.draw_text(
				">>",
				cheeseUtils.memoize.v2((stuff.drawFeatParams.rectPos.x + stuff.drawFeatParams.textOffset.x + stuff.menuData.feature_scale.x - 0.02 - (center/graphics.get_screen_width())/2)*2-1, (stuff.drawFeatParams.rectPos.y + stuff.drawFeatParams.textOffset.y + (stuff.menuData.feature_offset * k))*-2+1),
				cheeseUtils.memoize.v2(10, 10),
				stuff.drawFeatParams.textSize,
				func.convert_rgba_to_int(stuff.drawFeatParams.colorText.r, stuff.drawFeatParams.colorText.g, stuff.drawFeatParams.colorText.b, stuff.drawFeatParams.colorText.a),
				0, 0
			)
		elseif stringtype:match(".*action.*") then
			
			scriptdraw.draw_text(
				v["name"],
				cheeseUtils.memoize.v2((stuff.drawFeatParams.rectPos.x + stuff.drawFeatParams.textOffset.x + offset - (center/graphics.get_screen_width())/2)*2-1, (stuff.drawFeatParams.rectPos.y + stuff.drawFeatParams.textOffset.y + (stuff.menuData.feature_offset * k))*-2+1),
				cheeseUtils.memoize.v2(10, 10),
				stuff.drawFeatParams.textSize,
				func.convert_rgba_to_int(stuff.drawFeatParams.colorText.r, stuff.drawFeatParams.colorText.g, stuff.drawFeatParams.colorText.b, stuff.drawFeatParams.colorText.a),
				0, 0
			)
		elseif stringtype:match(".*toggle.*") then
			
			cheeseUtils.draw_outline(
				cheeseUtils.memoize.v2((stuff.drawFeatParams.rectPos.x + stuff.drawFeatParams.textOffset.x + 0.00390625)*2-1, (stuff.drawFeatParams.rectPos.y + (stuff.menuData.feature_offset * k))*-2+1),
				cheeseUtils.memoize.v2(0.015625, 0.0277777777778),
				func.convert_rgba_to_int(stuff.drawFeatParams.colorText.r, stuff.drawFeatParams.colorText.g, stuff.drawFeatParams.colorText.b, stuff.drawFeatParams.colorText.a),
				2
			)
			if v.real_on then
				
				scriptdraw.draw_rect(
					cheeseUtils.memoize.v2((stuff.drawFeatParams.rectPos.x + stuff.drawFeatParams.textOffset.x + 0.00390625)*2-1, (stuff.drawFeatParams.rectPos.y + (stuff.menuData.feature_offset * k))*-2+1),
					cheeseUtils.memoize.v2(0.0140625, 0.025),
					func.convert_rgba_to_int(stuff.drawFeatParams.colorText.r, stuff.drawFeatParams.colorText.g, stuff.drawFeatParams.colorText.b, stuff.drawFeatParams.colorText.a)
				)
			end
			
			scriptdraw.draw_text(
				v.name,
				cheeseUtils.memoize.v2((stuff.drawFeatParams.rectPos.x + stuff.drawFeatParams.textOffset.x + 0.011328125 - (center/graphics.get_screen_width())/2)*2-1, (stuff.drawFeatParams.rectPos.y + stuff.drawFeatParams.textOffset.y + (stuff.menuData.feature_offset * k))*-2+1),
				cheeseUtils.memoize.v2(10, 10),
				stuff.drawFeatParams.textSize,
				func.convert_rgba_to_int(stuff.drawFeatParams.colorText.r, stuff.drawFeatParams.colorText.g, stuff.drawFeatParams.colorText.b, stuff.drawFeatParams.colorText.a),
				0, 0
			)
		end
		if v.type then
			if stringtype:match(".*value_str.*") and v.str_data then
				func.draw_feat(
					k,
					{
						name = "< "..tostring(v.str_data[v.real_value + 1]).." >",
						type = stuff.type_id.name_to_id["action"],
						center = scriptdraw.get_text_size(("< "..tostring(v.str_data[v.real_value + 1]).." >"):gsub(" ", "."), stuff.drawFeatParams.textSize, 0)
					},
					stuff.menuData.feature_scale.x - 0.05,
					nil,
					textSize
				)
			elseif stringtype:match(".*value_[if]") then
				local cutvalue = v.real_value
				if stringtype:match("_f") then
					cutvalue = (cutvalue * 10000) + 0.5
					cutvalue = math.floor(cutvalue)
					cutvalue = cutvalue / 10000
				end
				func.draw_feat(
					k,
					{
						name = "< "..tostring(cutvalue).." >",
						type = stuff.type_id.name_to_id["action"],
						center = scriptdraw.get_text_size(("< "..tostring(cutvalue).." >"):gsub(" ", "."), stuff.drawFeatParams.textSize, 0)
					},
						stuff.menuData.feature_scale.x - 0.05,
						nil,
					textSize
					)
			end
		end
	end

	stuff.draw_current_menu = {frameCounter = 1, time = utils.time_ms() + 33, currentSprite = stuff.menuData.header}
	function func.draw_current_menu()
		local sprite = func.load_sprite(stuff.menuData.header)
		if stuff.draw_current_menu.currentSprite ~= stuff.menuData.header then
			stuff.draw_current_menu.currentSprite = stuff.menuData.header
			stuff.draw_current_menu.time = 0
			stuff.draw_current_menu.frameCounter = 1
			if type(sprite) == "table" then
				stuff.draw_current_menu.time = utils.time_ms() + (sprite[stuff.draw_current_menu.frameCounter].delay or sprite.constant_delay or 33)
			end
		end
		stuff.drawHiddenOffset = 0
		for k, v in pairs(currentMenu) do
			if type(k) == "number" then
				if v.hidden then
					stuff.drawHiddenOffset = stuff.drawHiddenOffset + 1
				end
			end
		end
		if stuff.menuData.background_sprite.sprite and func.load_sprite(stuff.menuData.background_sprite.sprite, stuff.path.background) then
			scriptdraw.draw_sprite(
				func.load_sprite(stuff.menuData.background_sprite.sprite, stuff.path.background),
				cheeseUtils.memoize.v2((stuff.menuData.x + stuff.menuData.background_sprite.offset.x)*2-1, (stuff.menuData.y+stuff.menuData.background_sprite.offset.y+stuff.menuData.height/2+0.01458)*-2+1),
				stuff.menuData.background_sprite.size,
				0,
				func.convert_rgba_to_int(255, 255, 255, stuff.menuData.color.background.a)
			)
		else
			scriptdraw.draw_rect(
				cheeseUtils.memoize.v2(stuff.menuData.x*2-1, (stuff.menuData.y+stuff.menuData.border+stuff.menuData.height/2)*-2+1),
				cheeseUtils.memoize.v2(stuff.menuData.width*2, stuff.menuData.height*2),
				func.convert_rgba_to_int(stuff.menuData.color.background.r, stuff.menuData.color.background.g, stuff.menuData.color.background.b, stuff.menuData.color.background.a)
			)
		end
		if #currentMenu - stuff.drawHiddenOffset >= stuff.menuData.max_features  then
			stuff.maxDrawScroll = #currentMenu - stuff.drawHiddenOffset - stuff.menuData.max_features
		else
			stuff.maxDrawScroll = 0
		end
		if stuff.scroll > #currentMenu - stuff.drawHiddenOffset then
			stuff.scroll = #currentMenu - stuff.drawHiddenOffset
		elseif stuff.scroll < 1 and #currentMenu > 0 then
			stuff.scroll = 1
		end

		-- header border
		scriptdraw.draw_rect(cheeseUtils.memoize.v2(stuff.menuData.x*2-1, (stuff.menuData.y + stuff.menuData.border/2)*-2+1), cheeseUtils.memoize.v2(stuff.menuData.width*2, stuff.menuData.border*2), func.convert_rgba_to_int(stuff.menuData.color.border.r, stuff.menuData.color.border.g, stuff.menuData.color.border.b, stuff.menuData.color.border.a))

		local hiddenOffset = 0
		local drawnfeats = 0
		local text_size = ((graphics.get_screen_width()*graphics.get_screen_height())/3686400)*0.45+0.25
		for k, v in ipairs(currentMenu) do
			if type(k) == "number" then
				if v.hidden then
					hiddenOffset = hiddenOffset + 1
				elseif k <= stuff.drawScroll + hiddenOffset + stuff.menuData.max_features and k >= stuff.drawScroll + hiddenOffset + 1 then
					func.draw_feat(k - stuff.drawScroll - hiddenOffset, v, 0, hiddenOffset, text_size)
					drawnfeats = drawnfeats + 1
				end
			end
		end

		if stuff.menuData.footer.draw_footer then
			-- footer border
			local footer_border_y_pos
			if stuff.menuData.footer.footer_pos_related_to_background then
				footer_border_y_pos = (stuff.menuData.y + stuff.menuData.height + stuff.menuData.border*1.5)*-2+1
			else
				footer_border_y_pos = (stuff.menuData.y + (drawnfeats*stuff.menuData.feature_offset) + stuff.menuData.border*1.5)*-2+1
			end
			scriptdraw.draw_rect(cheeseUtils.memoize.v2(stuff.menuData.x*2-1, footer_border_y_pos), cheeseUtils.memoize.v2(stuff.menuData.width*2, stuff.menuData.border*2), func.convert_rgba_to_int(stuff.menuData.color.border.r, stuff.menuData.color.border.g, stuff.menuData.color.border.b, stuff.menuData.color.border.a))

			-- footer and text/scroll
			local footer_y_pos
			if stuff.menuData.footer.footer_pos_related_to_background then
				footer_y_pos = (stuff.menuData.y + stuff.menuData.height + stuff.menuData.border*2 + stuff.menuData.footer.footer_size/2)*-2+1
			else
				footer_y_pos = (stuff.menuData.y + (drawnfeats*stuff.menuData.feature_offset) + stuff.menuData.border*2 + stuff.menuData.footer.footer_size/2)*-2+1
			end
			scriptdraw.draw_rect(cheeseUtils.memoize.v2(stuff.menuData.x*2-1, footer_y_pos), cheeseUtils.memoize.v2(stuff.menuData.width*2, stuff.menuData.footer.footer_size*2), func.convert_rgba_to_int(stuff.menuData.color.footer.r, stuff.menuData.color.footer.g, stuff.menuData.color.footer.b, stuff.menuData.color.footer.a))

			local text_y_pos = footer_y_pos + 0.011111111
			scriptdraw.draw_text(tostring(stuff.menuData.footer.footer_text), cheeseUtils.memoize.v2((stuff.menuData.x - stuff.menuData.width/2 + stuff.menuData.footer.padding)*2-1, text_y_pos), cheeseUtils.memoize.v2(2, 2), text_size, func.convert_rgba_to_int(stuff.menuData.color.footer_text.r, stuff.menuData.color.footer_text.g, stuff.menuData.color.footer_text.b, stuff.menuData.color.footer_text.a), 0, 0)

			scriptdraw.draw_text(tostring(stuff.scroll.." / "..(#currentMenu - stuff.drawHiddenOffset)), cheeseUtils.memoize.v2((stuff.menuData.x + stuff.menuData.width/2 - stuff.menuData.footer.padding)*2-1, text_y_pos), cheeseUtils.memoize.v2(2, 2), text_size, func.convert_rgba_to_int(stuff.menuData.color.footer_text.r, stuff.menuData.color.footer_text.g, stuff.menuData.color.footer_text.b, stuff.menuData.color.footer_text.a), 16, 0)
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
				stuff.draw_current_menu.time = utils.time_ms() + (sprite[stuff.draw_current_menu.frameCounter].delay or sprite.constant_delay or 33)
			end
			sprite = sprite[stuff.draw_current_menu.frameCounter].sprite
		end
		if sprite then
			scriptdraw.draw_sprite(sprite, cheeseUtils.memoize.v2(stuff.menuData.x * 2 - 1, ((stuff.menuData.y+stuff.menuData.height/2) - (stuff.menuData.height/2 + ((scriptdraw.get_sprite_size(sprite).y*((2.56 * stuff.menuData.width) * (1000 / scriptdraw.get_sprite_size(sprite).x)) / (2560 / graphics.get_screen_width()))/2)/graphics.get_screen_height()))*-2+1), ((2.56 * stuff.menuData.width) * (1000 / scriptdraw.get_sprite_size(sprite).x)) / (2560 / graphics.get_screen_width()), 0, stuff.menuData.color.sprite)
		end
		system.wait(0)
	end

	--[[
		example of table_of_lines:
		{
			{"leftside", "rightside"},
			{"IP", "ddosing u rn"},
			{"Cheesus", "Christ"}
		}
		has to be in this structure, you can add more than three
	]]
	function func.draw_side_window(header_text, table_of_lines, v2pos, rect_color, rect_width, text_spacing, text_padding, text_color)
		text_color = text_color or 0xFFFFFFFF
		assert(
			type(header_text) == "string"
			and type(table_of_lines) == "table"
			and type(v2pos) == "userdata"
			and type(rect_color) == "number"
			and type(rect_width) == "number"
			and type(text_spacing) == "number"
			and type(text_padding) == "number"
			and type(text_color) == "number",
			"one or more draw_side_window args were invalid"
		)
		local rect_height = #table_of_lines*text_spacing+0.07125
		v2pos.y = v2pos.y-(rect_height/2)

		
		scriptdraw.draw_rect(v2pos, cheeseUtils.memoize.v2(rect_width, rect_height), rect_color)

		local text_size = graphics.get_screen_width()*graphics.get_screen_height()/3686400*0.75+0.25
		-- Header text
		scriptdraw.draw_text(header_text, cheeseUtils.memoize.v2(v2pos.x - scriptdraw.get_text_size(header_text, text_size, 0).x/graphics.get_screen_width(), v2pos.y+(rect_height/2)-0.015), cheeseUtils.memoize.v2(2, 2), text_size, text_color, 0, 0)
		-- table_of_lines
		for k, v in ipairs(table_of_lines) do
			v[1] = tostring(v[1])
			v[2] = tostring(v[2])
			local pos_y = v2pos.y-k*text_spacing+rect_height/2-0.03
			scriptdraw.draw_text(v[1], cheeseUtils.memoize.v2(v2pos.x-rect_width/2+text_padding, pos_y), cheeseUtils.memoize.v2(2, 2), text_size, text_color, 0, 2)
			scriptdraw.draw_text(v[2], cheeseUtils.memoize.v2(v2pos.x+rect_width/2-text_padding, pos_y), cheeseUtils.memoize.v2(2, 2), text_size, text_color, 16, 2)
		end
	end

	--Hotkey functions
	function func.get_hotkey(keyTable, vkTable, singlekey)
		local current_key
		local excludedkeys = {}
		while not keyTable[1] do
			if func.get_key(0x1B):is_down() then
				return "escaped"
			end
			for k, v in pairs(stuff.char_codes) do
				if func.get_key(v):is_down() then
					if v ~= 0x0D or singlekey  then
						if v ~= 0xA0 and v ~= 0xA1 and v ~= 0xA2 and v ~= 0xA3 and v ~= 0xA4 and v ~= 0xA5 and not singlekey then
							keyTable[1] = "NOMOD"
						end
						if singlekey then
							return k, v
						else
							keyTable[#keyTable + 1] = k
							vkTable[#vkTable+1] = v
							current_key = v
							excludedkeys[v] = true
						end
					end
				end
			end
			system.wait(0)
		end

		if not singlekey then
			while func.get_key(current_key):is_down() do
				for k, v in pairs(stuff.char_codes) do
					if func.get_key(v):is_down() and not excludedkeys[v] and v ~= 0xA0 and v ~= 0xA1 and v ~= 0xA2 and v ~= 0xA3 and v ~= 0xA4 and v ~= 0xA5 then
						excludedkeys[v] = true
						keyTable[#keyTable + 1] = k
						vkTable[#vkTable+1] = v
					end
				end
				system.wait(0)
			end

			while not func.get_key(0x1B):is_down() and not func.get_key(0x0D):is_down() do
				for k, v in pairs(stuff.char_codes) do
					if func.get_key(v):is_down() then
						return false
					end
				end
				system.wait(0)
			end

			return func.get_key(0x0D):is_down() or "escaped"
		end
	end

	function func.draw_hotkey(keyTable)
		while true do
			for i = 0, 360 do
				controls.disable_control_action(0, i, true)
			end
			local concatenated = table.concat(keyTable, "+")
			scriptdraw.draw_rect(cheeseUtils.memoize.v2(0, 0), cheeseUtils.memoize.v2(2, 2), 0x7D000000)
			scriptdraw.draw_text(concatenated, cheeseUtils.memoize.v2(-(scriptdraw.get_text_size(concatenated, 1, 0).x/graphics.get_screen_width())), cheeseUtils.memoize.v2(2, 2), 1, 0xffffffff, 1 << 1, 0)
			system.wait(0)
		end
	end


	function func.start_hotkey_process(feat)
		stuff.menuData.menuToggle = false
		local keyTable = {}
		local vkTable = {}

		local drawThread = menu.create_thread(func.draw_hotkey, keyTable)

		while func.get_key(stuff.vkcontrols.setHotkey):is_down() do
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
					vkTable[k] = nil
				end
			end
		until response

		local keyString = table.concat(keyTable, "|")

		if response ~= "escaped" then
			stuff.hotkeys_to_vk[keyString] = vkTable
			if not stuff.hotkeys[keyString] then
				stuff.hotkeys[keyString] = {}
			end
			stuff.hotkeys[keyString][feat.hierarchy_key] = true
			feat.hotkey = keyString
			gltw.write(stuff.hotkeys, "hotkeys", stuff.path.hotkeys, nil, true)
		end

		menu.delete_thread(drawThread)
		while func.get_key(0x0D):is_down() or func.get_key(0x1B):is_down() do -- enter and esc
			controls.disable_control_action(0, 200, true)
			system.wait(0)
		end
		controls.disable_control_action(0, 200, true)
		stuff.menuData.menuToggle = true
		return response ~= "escaped" and response
	end

	--End of functions

	--threads
	menu.create_thread(function()
		local side_window_pos = v2((stuff.menuData.x + stuff.menuData.width + stuff.menuData.side_window.offset.x)*2-1, (stuff.menuData.y + stuff.menuData.side_window.offset.y)*-2+1)
		while true do
			if stuff.menuData.menuToggle then
				func.draw_current_menu()
				if currentMenu and stuff.menuData.side_window.on then
					local pid = currentMenu.pid
					if not pid and currentMenu[stuff.scroll + stuff.scrollHiddenOffset] then
						pid = currentMenu[stuff.scroll + stuff.scrollHiddenOffset].pid
					end
					if pid and pid ~= stuff.pid then
						if not stuff.playerIds[pid].hidden then
							stuff.player_info[1][2] = tostring(pid)
							stuff.player_info[10][2] = func.convert_int_ip(player.get_player_ip(pid))
							stuff.player_info[11][2] = tostring(player.get_player_scid(pid))
							stuff.player_info[12][2] = string.format("%X", player.get_player_host_token(pid))
							stuff.player_info.max_health = "/"..math.floor(player.get_player_max_health(pid))
							stuff.player_info.name = tostring(player.get_player_name(pid))
							stuff.pid = pid
						end
					end
					if pid then
						side_window_pos.x, side_window_pos.y = (stuff.menuData.x + stuff.menuData.width + stuff.menuData.side_window.offset.x)*2-1, (stuff.menuData.y + stuff.menuData.side_window.offset.y)*-2+1
						native.call(0xBE8CD9BE829BBEBF, player.get_player_ped(stuff.pid), stuff.proofs.bulletProof, stuff.proofs.fireProof, stuff.proofs.explosionProof, stuff.proofs.collisionProof, stuff.proofs.meleeProof, stuff.proofs.steamProof, stuff.proofs.p7, stuff.proofs.drownProof)
						stuff.player_info[2][2] = player.is_player_god(stuff.pid) and "Yes" or "No"
						stuff.player_info[3][2] = (stuff.proofs.bulletProof:__tointeger()|stuff.proofs.fireProof:__tointeger()|stuff.proofs.explosionProof:__tointeger()|stuff.proofs.collisionProof:__tointeger()|stuff.proofs.meleeProof:__tointeger()|stuff.proofs.steamProof:__tointeger()|stuff.proofs.p7:__tointeger()|stuff.proofs.drownProof:__tointeger()) == 1 and "Yes" or "No"
						stuff.player_info[4][2] = player.is_player_vehicle_god(stuff.pid) and "Yes" or "No"
						stuff.player_info[5][2] = player.is_player_modder(stuff.pid, -1) and "Yes" or "No"
						stuff.player_info[6][2] = player.is_player_host(stuff.pid) and "Yes" or "No"
						stuff.player_info[7][2] = player.get_player_wanted_level(stuff.pid)
						stuff.player_info[8][2] = math.floor(player.get_player_health(stuff.pid))..stuff.player_info.max_health
						stuff.player_info[9][2] = math.floor(player.get_player_armour(stuff.pid)).."/50"
						stuff.player_info[13][2] = player.get_player_host_priority(stuff.pid)
						func.draw_side_window(
							stuff.player_info.name,
							stuff.player_info,
							side_window_pos,
							func.convert_rgba_to_int(stuff.menuData.color.side_window.r, stuff.menuData.color.side_window.g, stuff.menuData.color.side_window.b, stuff.menuData.color.side_window.a),
							stuff.menuData.side_window.width, stuff.menuData.side_window.spacing, stuff.menuData.side_window.padding,
							func.convert_rgba_to_int(stuff.menuData.color.side_window_text.r, stuff.menuData.color.side_window_text.g, stuff.menuData.color.side_window_text.b, stuff.menuData.color.side_window_text.a)
						)
					end
				end
				controls.disable_control_action(0, 172, true)
				controls.disable_control_action(0, 27, true)
			else
				system.wait(0)
			end
		end
	end, nil)

	menu.create_thread(function()
		while true do
			func.do_key(500, stuff.vkcontrols.open, false, function() -- F4
				stuff.menuData.menuToggle = not stuff.menuData.menuToggle
			end)
			if currentMenu.hidden or not currentMenu then
				currentMenu = stuff.previousMenus[#stuff.previousMenus].menu
				stuff.scroll = stuff.previousMenus[#stuff.previousMenus].scroll
				stuff.drawScroll = stuff.previousMenus[#stuff.previousMenus].drawScroll
				stuff.scrollHiddenOffset = stuff.previousMenus[#stuff.previousMenus].scrollHiddenOffset
				stuff.previousMenus[#stuff.previousMenus] = nil
			end
			local pid = player.player_id()
			stuff.playerIds[pid].name = player.get_player_name(pid)
			if stuff.playerIds[pid].hidden then
				stuff.playerIds[pid].hidden = false
				stuff.playerIds[pid].name = player.get_player_name(pid)
				func.reset_player_submenu(pid)
			end
			system.wait(0)
		end
	end, nil)
	menu.create_thread(function()
		while true do
			system.wait(0)
			if stuff.menuData.menuToggle then
				func.do_key(500, stuff.vkcontrols.setHotkey, false, function() -- F11
					if func.get_key(0x10):is_down() and stuff.hotkeys[currentMenu[stuff.scroll + stuff.scrollHiddenOffset].hotkey] then
						stuff.hotkeys[currentMenu[stuff.scroll + stuff.scrollHiddenOffset].hotkey][currentMenu[stuff.scroll + stuff.scrollHiddenOffset].hierarchy_key] = nil
						if not next(stuff.hotkeys[currentMenu[stuff.scroll + stuff.scrollHiddenOffset].hotkey]) then
							stuff.hotkeys[currentMenu[stuff.scroll + stuff.scrollHiddenOffset].hotkey] = nil
						end
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
			end
		end
	end,nil)
	menu.create_thread(function()
		while true do
			system.wait(0)
			if stuff.menuData.menuToggle then
				func.do_key(500, stuff.vkcontrols.down, true, function() -- downKey
					local old_scroll = stuff.scroll + stuff.scrollHiddenOffset
					if stuff.scroll + stuff.drawHiddenOffset >= #currentMenu and #currentMenu - stuff.drawHiddenOffset > 1 then
						stuff.scroll = 1
						stuff.drawScroll = 0
					elseif #currentMenu - stuff.drawHiddenOffset > 1 then
						stuff.scroll = stuff.scroll + 1
						if stuff.scroll - stuff.drawScroll >= (stuff.menuData.max_features - 1) and stuff.drawScroll < stuff.maxDrawScroll then
							stuff.drawScroll = stuff.drawScroll + 1
						end
					end
					if old_scroll ~= (stuff.scroll + stuff.scrollHiddenOffset) then
						currentMenu[old_scroll]:activate_hl_func()
						if currentMenu[stuff.scroll + stuff.scrollHiddenOffset] then
							currentMenu[stuff.scroll + stuff.scrollHiddenOffset]:activate_hl_func()
						end
					end
				end)
			end
		end
	end, nil)
	menu.create_thread(function()
		while true do
			system.wait(0)
			if stuff.menuData.menuToggle then
				func.do_key(500, stuff.vkcontrols.up, true, function() -- upKey
					local old_scroll = stuff.scroll + stuff.scrollHiddenOffset
					if stuff.scroll <= 1 and #currentMenu - stuff.drawHiddenOffset > 1 then
						stuff.scroll = #currentMenu
						stuff.drawScroll = stuff.maxDrawScroll
					elseif #currentMenu - stuff.drawHiddenOffset > 1 then
						stuff.scroll = stuff.scroll - 1
						if stuff.scroll - stuff.drawScroll <= 2 and stuff.drawScroll > 0 then
							stuff.drawScroll = stuff.drawScroll - 1
						end
					end
					if old_scroll ~= (stuff.scroll + stuff.scrollHiddenOffset) then
						currentMenu[old_scroll]:activate_hl_func()
						if currentMenu[stuff.scroll + stuff.scrollHiddenOffset] then
							currentMenu[stuff.scroll + stuff.scrollHiddenOffset]:activate_hl_func()
						end
					end
				end)
			end
		end
	end,nil)
	menu.create_thread(function()
		while true do
			system.wait(0)
			if stuff.menuData.menuToggle then
				func.do_key(500, stuff.vkcontrols.select, true, function() --enter
					if currentMenu[stuff.scroll + stuff.scrollHiddenOffset] then
						if currentMenu[stuff.scroll + stuff.scrollHiddenOffset].type == stuff.type_id.name_to_id["parent"] and not currentMenu[stuff.scroll + stuff.scrollHiddenOffset].hidden then
							currentMenu[stuff.scroll + stuff.scrollHiddenOffset]:activate_hl_func()
							stuff.previousMenus[#stuff.previousMenus + 1] = {menu = currentMenu, scroll = stuff.scroll, drawScroll = stuff.drawScroll, scrollHiddenOffset = stuff.scrollHiddenOffset}
							currentMenu = currentMenu[stuff.scroll + stuff.scrollHiddenOffset]
							currentMenu:activate_feat_func()
							stuff.scroll = 1
							system.wait(0)
							stuff.drawScroll = 0
							stuff.scrollHiddenOffset = 0
							if currentMenu[stuff.scroll + stuff.scrollHiddenOffset] then
								currentMenu[stuff.scroll + stuff.scrollHiddenOffset]:activate_hl_func()
							end
							while func.get_key(stuff.vkcontrols.select):is_down() do
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
			end
		end
	end, nil)
	menu.create_thread(function()
		while true do
			system.wait(0)
			if stuff.menuData.menuToggle then
				func.do_key(500, stuff.vkcontrols.back, false, function() --backspace
					if stuff.previousMenus[#stuff.previousMenus] then
						if currentMenu[stuff.scroll + stuff.scrollHiddenOffset] then
							currentMenu[stuff.scroll + stuff.scrollHiddenOffset]:activate_hl_func()
						end
						currentMenu = stuff.previousMenus[#stuff.previousMenus].menu
						stuff.scroll = stuff.previousMenus[#stuff.previousMenus].scroll
						stuff.drawScroll = stuff.previousMenus[#stuff.previousMenus].drawScroll
						stuff.scrollHiddenOffset = stuff.previousMenus[#stuff.previousMenus].scrollHiddenOffset
						stuff.previousMenus[#stuff.previousMenus] = nil
						currentMenu[stuff.scroll + stuff.scrollHiddenOffset]:activate_hl_func()
					end
				end)
			end
		end
	end, nil)
	menu.create_thread(function()
		while true do
			system.wait(0)
			if stuff.menuData.menuToggle then
				func.do_key(500, stuff.vkcontrols.left, true, function() -- left
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
									currentMenu[stuff.scroll + stuff.scrollHiddenOffset].value = tonumber(currentMenu[stuff.scroll + stuff.scrollHiddenOffset].real_value) - currentMenu[stuff.scroll + stuff.scrollHiddenOffset].real_mod
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
		end
	end, nil)
	menu.create_thread(function()
		while true do
			if stuff.menuData.menuToggle then
				func.do_key(500, stuff.vkcontrols.right, true, function() -- right
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
									currentMenu[stuff.scroll + stuff.scrollHiddenOffset].value = tonumber(currentMenu[stuff.scroll + stuff.scrollHiddenOffset].real_value) + currentMenu[stuff.scroll + stuff.scrollHiddenOffset].real_mod
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
			system.wait(0)
		end
	end, nil)


	--Hotkey thread
	menu.create_thread(function()
		while true do
			if native.call(0x5FCF4D7069B09026):__tointeger() ~= 1 and not stuff.menuData.chatBoxOpen then
				for k, v in pairs(stuff.hotkeys) do
					if func.get_key(table.unpack(stuff.hotkeys_to_vk[k])):is_down() and (not (func.get_key(0x10):is_down() or func.get_key(0x11):is_down() or func.get_key(0x12):is_down()) or not (k:match("NOMOD"))) then
						for k, v in pairs(stuff.hotkeys[k]) do
							if stuff.hotkey_feature_hierarchy_keys[k] then
								for k, v in pairs(stuff.hotkey_feature_hierarchy_keys[k]) do
									if v.on ~= nil then
										v.on = not v.on
										if stuff.hotkey_notifications.toggle then
											menu.notify("Turned "..v.name.." "..(v.on and "on" or "off"), "Cheese Menu", 3, func.convert_rgba_to_int(stuff.menuData.color.notifications.r, stuff.menuData.color.notifications.g, stuff.menuData.color.notifications.b, stuff.menuData.color.notifications.a))
										end
									else
										v:activate_feat_func()
										if stuff.hotkey_notifications.action then
											menu.notify("Activated "..v.name, "Cheese Menu", 3, func.convert_rgba_to_int(stuff.menuData.color.notifications.r, stuff.menuData.color.notifications.g, stuff.menuData.color.notifications.b, stuff.menuData.color.notifications.a))
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
	menu.notify("Controls can be found in\nScript Features > Cheese Menu > Controls", "CheeseMenu by GhostOne\n"..stuff.controls.open.." to open", 6, 0x00ff00)

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

		menu_configuration_features.menuXfeat.value = math.floor(stuff.menuData.x*graphics.get_screen_width())
		menu_configuration_features.menuYfeat.value = math.floor(stuff.menuData.y*graphics.get_screen_height())
		menu_configuration_features.maxfeats.value = math.floor(stuff.menuData.max_features)
		menu_configuration_features.menuWidth.value = math.floor(stuff.menuData.width*graphics.get_screen_width())
		menu_configuration_features.featXfeat.value = math.floor(stuff.menuData.feature_scale.x*graphics.get_screen_width())
		menu_configuration_features.featYfeat.value = math.floor(stuff.menuData.feature_scale.y*graphics.get_screen_height())
		menu_configuration_features.feature_offset.value = math.floor(stuff.menuData.feature_offset*graphics.get_screen_height())
		menu_configuration_features.border.value = math.floor(stuff.menuData.border*graphics.get_screen_height())
		menu_configuration_features.backgroundsize.value = stuff.menuData.background_sprite.size
		menu_configuration_features.backgroundoffsetx.value = math.floor(stuff.menuData.background_sprite.offset.x*graphics.get_screen_width())
		menu_configuration_features.backgroundoffsety.value = math.floor(stuff.menuData.background_sprite.offset.y*graphics.get_screen_height())
		menu_configuration_features.footer_size.value = math.floor(stuff.menuData.footer.footer_size*graphics.get_screen_height())
		menu_configuration_features.padding.value = math.floor(stuff.menuData.footer.padding*graphics.get_screen_width())
		menu_configuration_features.draw_footer.on = stuff.menuData.footer.draw_footer
		menu_configuration_features.footer_pos_related_to_background.on = stuff.menuData.footer.footer_pos_related_to_background
		menu_configuration_features.side_window_offsetx.value = math.floor(stuff.menuData.side_window.offset.x*graphics.get_screen_width())
		menu_configuration_features.side_window_offsety.value = math.floor(stuff.menuData.side_window.offset.y*graphics.get_screen_height())
		menu_configuration_features.side_window_spacing.value = math.floor(stuff.menuData.side_window.spacing*graphics.get_screen_height())
		menu_configuration_features.side_window_padding.value = math.floor(stuff.menuData.side_window.padding*graphics.get_screen_width())
		menu_configuration_features.side_window_width.value = math.floor(stuff.menuData.side_window.width*graphics.get_screen_width())
		menu_configuration_features.side_window_on.on = stuff.menuData.side_window.on

		for k, v in pairs(stuff.menuData.color) do
			if type(v) == "table" then
				menu_configuration_features[k].r.value = v.r
				menu_configuration_features[k].g.value = v.g
				menu_configuration_features[k].b.value = v.b
				menu_configuration_features[k].a.value = v.a
			else
				menu_configuration_features[k].r.value = func.convert_int_to_rgba(v, "r")
				menu_configuration_features[k].g.value = func.convert_int_to_rgba(v, "g")
				menu_configuration_features[k].b.value = func.convert_int_to_rgba(v, "b")
				menu_configuration_features[k].a.value = func.convert_int_to_rgba(v, "a")
			end
		end

		for k, v in pairs(menu_configuration_features.headerfeat.str_data) do
			if v == stuff.menuData.header then
				menu_configuration_features.headerfeat.value = k - 1
			end
		end

		for k, v in pairs(menu_configuration_features.backgroundfeat.str_data) do
			if v == stuff.menuData.header then
				menu_configuration_features.backgroundfeat.value = k - 1
			end
		end

	end):set_str_data(stuff.menuData.files.ui)

	menu_configuration_features.menuXfeat = menu.add_feature("Menu pos X", "autoaction_value_i", menu_configuration_features.cheesemenuparent.id, function(f)
		if func.get_key(0x65):is_down() or func.get_key(0x0D):is_down() then
			local stat, num = input.get("num", "", 10, 3)
			if stat == 0 and tonumber(num) then
				stuff.menuData.x = num/graphics.get_screen_height()
				f.value = num
			end
		end
		stuff.menuData.x = f.value/graphics.get_screen_width()
	end)
	menu_configuration_features.menuXfeat.max = graphics.get_screen_width()
	menu_configuration_features.menuXfeat.mod = 1
	menu_configuration_features.menuXfeat.min = -graphics.get_screen_width()
	menu_configuration_features.menuXfeat.value = math.floor(stuff.menuData.x*graphics.get_screen_width())

	menu_configuration_features.menuYfeat = menu.add_feature("Menu pos Y", "autoaction_value_i", menu_configuration_features.cheesemenuparent.id, function(f)
		if func.get_key(0x65):is_down() or func.get_key(0x0D):is_down() then
			local stat, num = input.get("num", "", 10, 3)
			if stat == 0 and tonumber(num) then
				stuff.menuData.y = num/graphics.get_screen_height()
				f.value = num
			end
		end
		stuff.menuData.y = f.value/graphics.get_screen_height()
	end)
	menu_configuration_features.menuYfeat.max = graphics.get_screen_height()
	menu_configuration_features.menuYfeat.mod = 1
	menu_configuration_features.menuYfeat.min = -graphics.get_screen_height()
	menu_configuration_features.menuYfeat.value = math.floor(stuff.menuData.y*graphics.get_screen_height())

	menu_configuration_features.maxfeats = menu.add_feature("Max features", "autoaction_value_i", menu_configuration_features.cheesemenuparent.id, function(f)
		stuff.menuData:set_max_features(f.value)
	end)
	menu_configuration_features.maxfeats.max = 50
	menu_configuration_features.maxfeats.mod = 1
	menu_configuration_features.maxfeats.min = 1
	menu_configuration_features.maxfeats.value = math.floor(stuff.menuData.max_features)

	menu_configuration_features.menuWidth = menu.add_feature("Menu width", "autoaction_value_i", menu_configuration_features.cheesemenuparent.id, function(f)
		stuff.menuData.width = f.value/graphics.get_screen_width()
	end)
	menu_configuration_features.menuWidth.max = graphics.get_screen_width()
	menu_configuration_features.menuWidth.mod = 1
	menu_configuration_features.menuWidth.min = -graphics.get_screen_width()
	menu_configuration_features.menuWidth.value = math.floor(stuff.menuData.width*graphics.get_screen_width())

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


	menu_configuration_features.border = menu.add_feature("Border", "autoaction_value_i", menu_configuration_features.cheesemenuparent.id, function(f)
		stuff.menuData.border = f.value/graphics.get_screen_height()
	end)
	menu_configuration_features.border.max = graphics.get_screen_height()
	menu_configuration_features.border.mod = 1
	menu_configuration_features.border.min = -graphics.get_screen_height()
	menu_configuration_features.border.value = math.floor(stuff.menuData.border*graphics.get_screen_height())

	menu_configuration_features.headerfeat = menu.add_feature("Header", "autoaction_value_str", menu_configuration_features.cheesemenuparent.id, function(f)
		if f.str_data[f.value + 1] == "NONE" then
			stuff.menuData.header = nil
		else
			stuff.menuData.header = f.str_data[f.value + 1]
		end
	end)
	menu_configuration_features.headerfeat:set_str_data({"NONE", table.unpack(stuff.menuData.files.headers)})

	menu_configuration_features.controls = menu.add_feature("Controls", "parent", menu_configuration_features.cheesemenuparent.id)
	menu.add_feature("Save controls", "action", menu_configuration_features.controls.id, function()
		gltw.write(stuff.controls, "controls", stuff.path.cheesemenu)
	end)
	for k, v in pairs(stuff.controls) do
		menu.add_feature(k, "action_value_str", menu_configuration_features.controls.id, function(f)
			for k, v in pairs(stuff.char_codes) do
				while func.get_key(v):is_down() do
					system.wait(0)
				end
			end
			menu.notify("Press any button\nESC to cancel", "Cheese Menu", 3, func.convert_rgba_to_int(stuff.menuData.color.notifications.r, stuff.menuData.color.notifications.g, stuff.menuData.color.notifications.b, stuff.menuData.color.notifications.a))
			local disablethread = menu.create_thread(stuff.disable_all_controls, nil)
			local stringkey, vk = func.get_hotkey({}, {}, true)
			if stringkey ~= "escaped" then
				stuff.controls[k] = stringkey
				stuff.vkcontrols[k] = vk
				f:set_str_data({stringkey})
			end
			menu.delete_thread(disablethread)
		end):set_str_data({v})
	end

	-- Player Info
	menu_configuration_features.side_window = menu.add_feature("Player Info Window", "parent", menu_configuration_features.cheesemenuparent.id)

		-- On
		menu_configuration_features.side_window_on = menu.add_feature("Draw", "toggle", menu_configuration_features.side_window.id, function(f)
			stuff.menuData.side_window.on = f.on
		end)
		menu_configuration_features.side_window_on.on = stuff.menuData.side_window.on

		-- Offset
		menu_configuration_features.side_window_offsetx = menu.add_feature("X Offset", "autoaction_value_i", menu_configuration_features.side_window.id, function(f)
			if func.get_key(0x65):is_down() or func.get_key(0x0D):is_down() then
				local stat, num = input.get("num", "", 10, 3)
				if stat == 0 and tonumber(num) then
					stuff.menuData.side_window.offset.x = num/graphics.get_screen_height()
					f.value = num
				end
			end
			stuff.menuData.side_window.offset.x = f.value/graphics.get_screen_width()
		end)
		menu_configuration_features.side_window_offsetx.max = graphics.get_screen_width()
		menu_configuration_features.side_window_offsetx.mod = 1
		menu_configuration_features.side_window_offsetx.min = -graphics.get_screen_width()
		menu_configuration_features.side_window_offsetx.value = math.floor(stuff.menuData.side_window.offset.x*graphics.get_screen_width())

		menu_configuration_features.side_window_offsety = menu.add_feature("Y Offset", "autoaction_value_i", menu_configuration_features.side_window.id, function(f)
			if func.get_key(0x65):is_down() or func.get_key(0x0D):is_down() then
				local stat, num = input.get("num", "", 10, 3)
				if stat == 0 and tonumber(num) then
					stuff.menuData.side_window.offset.y = num/graphics.get_screen_height()
					f.value = num
				end
			end
			stuff.menuData.side_window.offset.y = f.value/graphics.get_screen_height()
		end)
		menu_configuration_features.side_window_offsety.max = graphics.get_screen_height()
		menu_configuration_features.side_window_offsety.mod = 1
		menu_configuration_features.side_window_offsety.min = -graphics.get_screen_height()
		menu_configuration_features.side_window_offsety.value = math.floor(stuff.menuData.side_window.offset.y*graphics.get_screen_height())

		-- Spacing
		menu_configuration_features.side_window_spacing = menu.add_feature("Spacing", "autoaction_value_i", menu_configuration_features.side_window.id, function(f)
			if func.get_key(0x65):is_down() or func.get_key(0x0D):is_down() then
				local stat, num = input.get("num", "", 10, 3)
				if stat == 0 and tonumber(num) then
					stuff.menuData.side_window.spacing = num/graphics.get_screen_height()
					f.value = num
				end
			end
			stuff.menuData.side_window.spacing = f.value/graphics.get_screen_height()
		end)
		menu_configuration_features.side_window_spacing.max = graphics.get_screen_height()
		menu_configuration_features.side_window_spacing.mod = 1
		menu_configuration_features.side_window_spacing.min = -graphics.get_screen_height()
		menu_configuration_features.side_window_spacing.value = math.floor(stuff.menuData.side_window.spacing*graphics.get_screen_height())

		-- Padding
		menu_configuration_features.side_window_padding = menu.add_feature("Padding", "autoaction_value_i", menu_configuration_features.side_window.id, function(f)
			if func.get_key(0x65):is_down() or func.get_key(0x0D):is_down() then
				local stat, num = input.get("num", "", 10, 3)
				if stat == 0 and tonumber(num) then
					stuff.menuData.side_window.padding = num/graphics.get_screen_height()
					f.value = num
				end
			end
			stuff.menuData.side_window.padding = f.value/graphics.get_screen_width()
		end)
		menu_configuration_features.side_window_padding.max = graphics.get_screen_width()
		menu_configuration_features.side_window_padding.mod = 1
		menu_configuration_features.side_window_padding.min = -graphics.get_screen_width()
		menu_configuration_features.side_window_padding.value = math.floor(stuff.menuData.side_window.padding*graphics.get_screen_width())

		-- Width
		menu_configuration_features.side_window_width = menu.add_feature("Width", "autoaction_value_i", menu_configuration_features.side_window.id, function(f)
			if func.get_key(0x65):is_down() or func.get_key(0x0D):is_down() then
				local stat, num = input.get("num", "", 10, 3)
				if stat == 0 and tonumber(num) then
					stuff.menuData.side_window.width = num/graphics.get_screen_height()
					f.value = num
				end
			end
			stuff.menuData.side_window.width = f.value/graphics.get_screen_width()
		end)
		menu_configuration_features.side_window_width.max = graphics.get_screen_width()
		menu_configuration_features.side_window_width.mod = 1
		menu_configuration_features.side_window_width.min = -graphics.get_screen_width()
		menu_configuration_features.side_window_width.value = math.floor(stuff.menuData.side_window.width*graphics.get_screen_width())

	-- End of Player Info


	menu_configuration_features.backgroundparent = menu.add_feature("Background", "parent", menu_configuration_features.cheesemenuparent.id)

	menu_configuration_features.backgroundfeat = menu.add_feature("Background", "autoaction_value_str", menu_configuration_features.backgroundparent.id, function(f)
		if f.str_data[f.value + 1] == "NONE" then
			stuff.menuData.background_sprite.sprite = nil
		else
			stuff.menuData.background_sprite.sprite = f.str_data[f.value + 1]
		end
	end)
	menu_configuration_features.backgroundfeat:set_str_data({"NONE", table.unpack(stuff.menuData.files.background)})

	menu.add_feature("Fit background to width", "action", menu_configuration_features.backgroundparent.id, function()
		if stuff.menuData.background_sprite.sprite then
			stuff.menuData.background_sprite:fit_size_to_width()
		end
	end)

	menu_configuration_features.backgroundoffsetx = menu.add_feature("Background pos X", "autoaction_value_i", menu_configuration_features.backgroundparent.id, function(f)
		if func.get_key(0x65):is_down() or func.get_key(0x0D):is_down() then
			local stat, num = input.get("num", "", 10, 3)
			if stat == 0 and tonumber(num) then
				stuff.menuData.background_sprite.offset.x = num/graphics.get_screen_width()
				f.value = num
			end
		end
		stuff.menuData.background_sprite.offset.x = f.value/graphics.get_screen_width()
	end)
	menu_configuration_features.backgroundoffsetx.max = graphics.get_screen_width()
	menu_configuration_features.backgroundoffsetx.mod = 1
	menu_configuration_features.backgroundoffsetx.min = -graphics.get_screen_width()
	menu_configuration_features.backgroundoffsetx.value = math.floor(stuff.menuData.background_sprite.offset.x*graphics.get_screen_width())

	menu_configuration_features.backgroundoffsety = menu.add_feature("Background pos Y", "autoaction_value_i", menu_configuration_features.backgroundparent.id, function(f)
		if func.get_key(0x65):is_down() or func.get_key(0x0D):is_down() then
			local stat, num = input.get("num", "", 10, 3)
			if stat == 0 and tonumber(num) then
				stuff.menuData.background_sprite.offset.y = num/graphics.get_screen_height()
				f.value = num
			end
		end
		stuff.menuData.background_sprite.offset.y = f.value/graphics.get_screen_height()
	end)
	menu_configuration_features.backgroundoffsety.max = graphics.get_screen_height()
	menu_configuration_features.backgroundoffsety.mod = 1
	menu_configuration_features.backgroundoffsety.min = -graphics.get_screen_height()
	menu_configuration_features.backgroundoffsety.value = math.floor(stuff.menuData.background_sprite.offset.y*graphics.get_screen_height())

	menu_configuration_features.backgroundsize = menu.add_feature("Background Size", "autoaction_value_f", menu_configuration_features.backgroundparent.id, function(f)
		stuff.menuData.background_sprite.size = f.value
	end)
	menu_configuration_features.backgroundsize.max = 1
	menu_configuration_features.backgroundsize.mod = 0.01
	menu_configuration_features.backgroundsize.value = stuff.menuData.background_sprite.size

	menu_configuration_features.footer = menu.add_feature("Footer", "parent", menu_configuration_features.cheesemenuparent.id)

	menu_configuration_features.footer_size = menu.add_feature("Footer Size", "autoaction_value_i", menu_configuration_features.footer.id, function(f)
		if func.get_key(0x65):is_down() or func.get_key(0x0D):is_down() then
			local stat, num = input.get("num", "", 10, 3)
			if stat == 0 and tonumber(num) then
				stuff.menuData.footer.footer_size = num/graphics.get_screen_height()
				f.value = num
			end
		end
		stuff.menuData.footer.footer_size = f.value/graphics.get_screen_height()
	end)
	menu_configuration_features.footer_size.max = graphics.get_screen_height()
	menu_configuration_features.footer_size.mod = 1
	menu_configuration_features.footer_size.min = 0
	menu_configuration_features.footer_size.value = math.floor(stuff.menuData.footer.footer_size*graphics.get_screen_height())

	menu_configuration_features.padding = menu.add_feature("Padding", "autoaction_value_i", menu_configuration_features.footer.id, function(f)
		if func.get_key(0x65):is_down() or func.get_key(0x0D):is_down() then
			local stat, num = input.get("num", "", 10, 3)
			if stat == 0 and tonumber(num) then
				stuff.menuData.footer.padding = num/graphics.get_screen_width()
				f.value = num
			end
		end
		stuff.menuData.footer.padding = f.value/graphics.get_screen_width()
	end)
	menu_configuration_features.padding.max = graphics.get_screen_width()
	menu_configuration_features.padding.mod = 1
	menu_configuration_features.padding.min = -graphics.get_screen_width()
	menu_configuration_features.padding.value = math.floor(stuff.menuData.footer.padding*graphics.get_screen_width())

	menu_configuration_features.draw_footer = menu.add_feature("Draw footer", "toggle", menu_configuration_features.footer.id, function(f)
		stuff.menuData.footer.draw_footer = f.on
	end)
	menu_configuration_features.draw_footer.on = stuff.menuData.footer.draw_footer

	menu_configuration_features.footer_pos_related_to_background = menu.add_feature("Footer position based on background", "toggle", menu_configuration_features.footer.id, function(f)
		stuff.menuData.footer.footer_pos_related_to_background = f.on
	end)
	menu_configuration_features.footer_pos_related_to_background.on = stuff.menuData.footer.footer_pos_related_to_background

	menu_configuration_features.footer_text = menu.add_feature("Footer Text", "action", menu_configuration_features.footer.id, function()
		local status, text = input.get("Footer Text", "", 50, 0)
		if status == 0 then
			stuff.menuData.footer.footer_text = tostring(text)
		end
	end)

	menu_configuration_features.hotkeyparent = menu.add_feature("Hotkey notifications", "parent", menu_configuration_features.cheesemenuparent.id)

	menu.add_feature("Toggle notification", "toggle", menu_configuration_features.hotkeyparent.id, function(f)
		stuff.hotkey_notifications.toggle = f.on
		gltw.write(stuff.hotkey_notifications, "hotkey notifications", stuff.path.hotkeys)
	end).on = stuff.hotkey_notifications.toggle
	menu.add_feature("Action notification", "toggle", menu_configuration_features.hotkeyparent.id, function(f)
		stuff.hotkey_notifications.action = f.on
		gltw.write(stuff.hotkey_notifications, "hotkey notifications", stuff.path.hotkeys)
	end).on = stuff.hotkey_notifications.action

	local colorParent = menu.add_feature("Colors", "parent", menu_configuration_features.cheesemenuparent.id)
	for k, v in pairs(stuff.menuData.color) do
		menu_configuration_features[k] = {}
		local vParent = menu.add_feature(k, "parent", colorParent.id)
		menu_configuration_features[k].r = menu.add_feature("Red", "autoaction_value_i", vParent.id, function(f)
			if func.get_key(0x65):is_down() or func.get_key(0x0D):is_down() then
				local stat, num = input.get("num", "", 10, 3)
				if stat == 0 and tonumber(num) then
					f.value = num
				end
			end
			stuff.menuData.color:set_color(k, f.value)
		end)
		menu_configuration_features[k].r.max = 255
		if type(v) == "table" then
			menu_configuration_features[k].r.value = v.r
		else
			menu_configuration_features[k].r.value = func.convert_int_to_rgba(v, "r")
		end
		menu_configuration_features[k].g = menu.add_feature("Green", "autoaction_value_i", vParent.id, function(f)
			if func.get_key(0x65):is_down() or func.get_key(0x0D):is_down() then
				local stat, num = input.get("num", "", 10, 3)
				if stat == 0 and tonumber(num) then
					f.value = num
				end
			end
			stuff.menuData.color:set_color(k, nil, f.value)
		end)
		menu_configuration_features[k].g.max = 255
		if type(v) == "table" then
			menu_configuration_features[k].g.value = v.g
		else
			menu_configuration_features[k].g.value = func.convert_int_to_rgba(v, "g")
		end
		menu_configuration_features[k].b = menu.add_feature("Blue", "autoaction_value_i", vParent.id, function(f)
			if func.get_key(0x65):is_down() or func.get_key(0x0D):is_down() then
				local stat, num = input.get("num", "", 10, 3)
				if stat == 0 and tonumber(num) then
					f.value = num
				end
			end
			stuff.menuData.color:set_color(k, nil, nil, f.value)
		end)
		menu_configuration_features[k].b.max = 255
		if type(v) == "table" then
			menu_configuration_features[k].b.value = v.b
		else
			menu_configuration_features[k].b.value = func.convert_int_to_rgba(v, "b")
		end
		menu_configuration_features[k].a = menu.add_feature("Alpha", "autoaction_value_i", vParent.id, function(f)
			if func.get_key(0x65):is_down() or func.get_key(0x0D):is_down() then
				local stat, num = input.get("num", "", 10, 3)
				if stat == 0 and tonumber(num) then
					f.value = num
				end
			end
			stuff.menuData.color:set_color(k, nil, nil, nil, f.value)
		end)
		menu_configuration_features[k].a.max = 255
		if type(v) == "table" then
			menu_configuration_features[k].a.value = v.a
		else
			menu_configuration_features[k].a.value = func.convert_int_to_rgba(v, "a")
		end
	end

	--changing menu functions to ui functions
	menu.add_feature = func.add_feature
	menu.add_player_feature = func.add_player_feature
	menu.delete_feature = func.delete_feature
	menu.delete_player_feature = func.delete_player_feature
	menu.get_player_feature = func.get_player_feature
	stuff.originals = {get_feature_by_hierarchy_key = menu.get_feature_by_hierarchy_key}
	menu.get_feature_by_hierarchy_key = function(hierarchy_key)
		local feat, duplicate
		feat = stuff.originals.get_feature_by_hierarchy_key(hierarchy_key)
		if feat then
			return feat
		else
			feat, duplicate = func.get_feature_by_hierarchy_key(hierarchy_key)
			if duplicate then
				return feat[1]
			else
				return feat
			end
		end
	end
	cheeseUIdata = stuff.menuData
	--
	func.set_player_feat_parent("Online Players", 0)
end
