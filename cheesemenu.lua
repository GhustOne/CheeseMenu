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

local version = "1.10"
local loadCurrentMenu
local httpTrustedOff

-- Version check
if menu.is_trusted_mode_enabled(1 << 3) and menu.is_trusted_mode_enabled(1 << 2) then
	menu.create_thread(function()
		local vercheckKeys = {ctrl = MenuKey(), space = MenuKey(), enter = MenuKey(), rshift = MenuKey()}
		vercheckKeys.ctrl:push_vk(0x11); vercheckKeys.space:push_vk(0x20); vercheckKeys.enter:push_vk(0x0D); vercheckKeys.rshift:push_vk(0xA1)

		local responseCode, githubVer = web.get("https://raw.githubusercontent.com/GhustOne/CheeseMenu/main/VERSION.txt")
		if responseCode == 200 then
			githubVer = githubVer:gsub("[\r\n]", "")
			if githubVer ~= version then
				local text_size = graphics.get_screen_width()*graphics.get_screen_height()/3686400*0.5+0.5
				local strings = {
					version_compare = "\nCurrent Version:"..version.."\nLatest Version:"..githubVer,
					version_compare_x_offset = v2(-scriptdraw.get_text_size("\nCurrent Version:"..version.."\nLatest Version:"..githubVer, text_size).x/graphics.get_screen_width(), 0),
					new_ver_x_offset = v2(-scriptdraw.get_text_size("New version available. Press CTRL or SPACE to skip or press ENTER or RIGHT SHIFT to update.", text_size).x/graphics.get_screen_width(), 0),
				}
				strings.changelog_rc, strings.changelog = web.get("https://raw.githubusercontent.com/GhustOne/CheeseMenu/main/CHANGELOG.txt")
				if strings.changelog_rc == 200 then
					strings.changelog = "\n\n\nChangelog:\n"..strings.changelog
				else
					strings.changelog = ""
				end
				strings.changelog_x_offset = v2(-scriptdraw.get_text_size(strings.changelog, text_size).x/graphics.get_screen_width(), 0)
				local stringV2size = v2(2, 2)
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
else
	if menu.is_trusted_mode_enabled(1 << 2) then
		httpTrustedOff = true
	else
		menu.notify("Trusted mode > Natives has to be on. If you wish for auto updates enable Http too.", "Cheese Menu", 5, 0x0000FF)
	end
end

local features
local currentMenu
local func
local stuff
local menu_configuration_features
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
		trusted_mode = 0,
		old_selected = 0,
		player_submenu_sort = 0,
		previousMenus = {},
		threads = {},
		feature_by_id = {},
		player_feature_by_id = {},
		feature_hints = {},
		player_feature_hints = {},
		path = {
			scripts = utils.get_appdata_path("PopstarDevs", "2Take1Menu").."\\scripts\\"
		},
		hotkeys = {},
		hotkey_cooldowns = {},
		hotkeys_to_vk = {},
		table_sort_functions = {
			[0] = function(a, b) return a.pid < b.pid end,
			function(a, b) return a.pid > b.pid end,
			function(a, b) return a.name:lower() < b.name:lower() end,
			function(a, b) return a.name:lower() > b.name:lower() end,
			function(a, b) return player.get_player_host_priority(a.pid) < player.get_player_host_priority(b.pid) end,
			function(a, b) return player.get_player_host_priority(a.pid) > player.get_player_host_priority(b.pid) end
		},
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
			setHotkey = "F11",
			specialKey = "LCONTROL",
			revealMouse = "X"
		},
		vkcontrols = {
			left = 0x25,
			up = 0x26,
			right = 0x27,
			down = 0x28,
			select = 0x0D,
			back = 0x08,
			open = 0x73,
			setHotkey = 0x7A,
			specialKey = 0xA2,
			revealMouse = 0x58
		},
		drawScroll = 0,
		maxDrawScroll = 0,
		menuData = {
			menuToggle = false,
			menuNav = true,
			inputBoxOpen = false,
			pos_x = 0.5,
			pos_y = 0.44652777777,
			width = 0.2,
			height = 0.305,
			border = 0.0013888,
			selector_speed = 1,
			slider = {
				width = 0.2,
				height = 0.01,
				heightActive = 0.025,
			},
			footer = {
				footer_y_offset = 0,
				padding = 0.0078125,
				footer_size = 0.019444444,
				draw_footer = true,
				footer_pos_related_to_background = false,
				footer_text = "Made by GhostOne",
			},
			fonts = {
				text = 0,
				footer = 0,
				hint = 0
			},
			side_window = {
				on = true,
				offset = {x = 0, y = 0},
				spacing = 0.0547222,
				width = 0.3,
				padding = 0.01
			},
			header = "cheese_menu.png",
			feature_offset = 0.025,
			feature_scale = {x = 0.2, y = 0.025},
			padding = {
				name = 0.003125,
				parent = 0.003125,
				value = 0.048125,
				slider = 0.003125,
			},
			text_size = (((graphics.get_screen_width()*graphics.get_screen_height())/3686400)*0.45+0.25),
			text_size_modifier = 1,
			footer_size_modifier = 1,
			hint_size_modifier = 1,
			text_y_offset = -0.0055555555,
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
	cheeseUIdata = stuff.menuData
	stuff.input = require("cheesemenu.libs.Get Input")
	local gltw = require("cheesemenu.libs.GLTW")
	local cheeseUtils = require("cheesemenu.libs.CheeseUtilities")
	assert(gltw, "GLTW library is not found, please install the menu with 'cheesemenu' folder.")

	stuff.menuData.color = {
		background = {r = 0, g = 0, b = 0, a = 0},
		sprite_background = {r = 255, g = 255, b = 255, a = 170},
		sprite = 0xE6FFFFFF,
		slider_active = {r = 255, g = 200, b = 0, a = 255},
		slider_background = {r = 0, g = 0, b = 0, a = 160},
		slider_text = {r = 0, g = 0, b = 0, a = 255},
		slider_selectedActive = {r = 255, g = 255, b = 255, a = 160},
		slider_selectedBackground = {r = 255, g = 160, b = 0, a = 180},
		feature_bottomLeft = {r = 255, g = 160, b = 0, a = 170},
		feature_topLeft = {r = 255, g = 160, b = 0, a = 170},
		feature_topRight = {r = 255, g = 160, b = 0, a = 170},
		feature_bottomRight = {r = 255, g = 160, b = 0, a = 170},
		feature_selected_bottomLeft = {r = 0, g = 0, b = 0, a = 200},
		feature_selected_topLeft = {r = 0, g = 0, b = 0, a = 200},
		feature_selected_topRight = {r = 0, g = 0, b = 0, a = 200},
		feature_selected_bottomRight = {r = 0, g = 0, b = 0, a = 200},
		text_selected = {r = 255, g = 200, b = 0, a = 180},
		text = {r = 0, g = 0, b = 0, a = 180},
		border = {r = 0, g = 0, b = 0, a = 180},
		footer = {r = 255, g = 160, b = 0, a = 170},
		footer_text = {r = 0, g = 0, b = 0, a = 180},
		notifications = {r = 255, g = 200, b = 0, a = 255},
		side_window_background = {r = 0, g = 0, b = 0, a = 150},
		side_window_text = {r = 255, g = 255, b = 255, a = 220},
		shortcut_background = {r = 255, g = 160, b = 0, a = 170},
		shortcut_text = {r = 0, g = 0, b = 0, a = 180}
	}

	stuff.path.cheesemenu = stuff.path.scripts.."cheesemenu\\"
	for k, v in pairs(utils.get_all_sub_directories_in_directory(stuff.path.cheesemenu)) do
		stuff.path[v] = stuff.path.cheesemenu..v.."\\"
	end

	stuff.menuData.background_sprite.fit_size_to_width = function(self)
		self.size = stuff.menuData.width*graphics.get_screen_width()/scriptdraw.get_sprite_size(func.load_sprite(stuff.path.background..(self.sprite or ""), stuff.menuData.background_sprite.loaded_sprites)).x
	end
	stuff.menuData.background_sprite.fit_size_to_height = function(self)
		self.size = stuff.menuData.height*graphics.get_screen_height()/scriptdraw.get_sprite_size(func.load_sprite(stuff.path.background..(self.sprite or ""), stuff.menuData.background_sprite.loaded_sprites)).y
	end

	stuff.image_ext = {"gif", "bmp", "jpg", "jpeg", "png", "2t1", "dds"}
	stuff.menuData.files.headers = {}
	for _, ext in pairs(stuff.image_ext) do
		for _, image in pairs(utils.get_all_files_in_directory(stuff.path.header, ext)) do
			stuff.menuData.files.headers[#stuff.menuData.files.headers + 1] = image
		end
	end
	for k, v in pairs(utils.get_all_sub_directories_in_directory(stuff.path.header)) do
		stuff.menuData.files.headers[#stuff.menuData.files.headers + 1] = v..".ogif"
	end

	stuff.menuData.files.ui = {}
	for k, v in pairs(utils.get_all_files_in_directory(stuff.path.ui, "lua")) do
		stuff.menuData.files.ui[k] = v:sub(1, #v - 4)
	end

	stuff.menuData.files.background = {}
	for _, ext in pairs(stuff.image_ext) do
		for k, v in pairs(utils.get_all_files_in_directory(stuff.path.background, "png")) do
			stuff.menuData.files.background[k] = v
		end
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
						colors[k] = cheeseUtils.convert_int_to_rgba(self[colorName], k)
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

	setmetatable(stuff.menuData.color, {__index = stuff.menuData_methods})

	function func.convert_int_ip(ip)
		local ipTable = {}
		ipTable[1] = ip >> 24 & 255
		ipTable[2] = ip >> 16 & 255
		ipTable[3] = ip >> 8 & 255
		ipTable[4] = ip & 255

		return table.concat(ipTable, ".")
	end

	gltw.read("hotkey notifications", stuff.path.hotkeys, stuff.hotkey_notifications, false, true)
	stuff.hotkeys = gltw.read("hotkeys", stuff.path.hotkeys, nil, false, true) or {}
	stuff.hierarchy_key_to_hotkey = {}
	for k, v in pairs(stuff.hotkeys) do
		stuff.hotkey_cooldowns[k] = 0

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

	stuff.saved_shortcuts = gltw.read("shortcuts", stuff.path.hotkeys, nil, false, true)

	--local originalGetInput = input.get
	if stuff.input then
		function input.get(title, default, len, Type)
			local originalmenuToggle = stuff.menuData.menuToggle
			stuff.menuData.menuToggle = false
			stuff.menuData.inputBoxOpen = true
			local status, gottenInput = stuff.input.get_input(title, default, len, Type)

			func.toggle_menu(originalmenuToggle)
			stuff.menuData.inputBoxOpen = false
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
			elseif k == "parent" then
				return t.type >> 15 & 1 == 0 and func.get_feature(t.parent_id) or func.get_player_feature(t.parent_id)
			elseif k == "value" or k == "min" or k == "mod" or k == "max" or k == "str_data" or k == "type" or k == "id" or k == "on" or k == "hidden" or k == "data" then
				if t.playerFeat and k ~= "str_data" and k ~= "type" and k ~= "id" and k ~= "hidden" and k ~= "data" then
					return stuff.rawget(t, "table_"..k)
				else
					return stuff.rawget(t, "real_"..k)
				end
			elseif k == "children" and t.type >> 11 & 1 ~= 0 then
				return t:get_children()
			elseif k == "hint" then
				local hintTable = t.type >> 15 & 1 ~= 0 and stuff.player_feature_hints or stuff.feature_hints
				return hintTable[t.id].str
			--[[ else
				return stuff.rawget(t, k) ]]
			end
		end,

		__newindex = function(t, k, v)
			assert(k ~= "id" and k ~= "children" and k ~= "type" and k ~= "str_data" and k ~= "is_highlighted", "'"..k.."' is read only")
			if k == "on" and type(v) == "boolean" then
				if t.real_on == v then
					return
				end
				--[[ if t.type >> 11 & 1 ~= 0 and t.real_on ~= nil then
					func.check_scroll(t.index, (t.parent_id > 0 and t.parent or features), not v)
				end ]]
				stuff.rawset(t, "real_on", v)

				if t.feats then
					for pid, feat in pairs(t.feats) do
						if player.is_player_valid(pid) then
							feat.on = v
							--[[ if feat.type >> 11 & 1 ~= 0 then
								func.check_scroll(feat.index, (feat.parent_id > 0 and stuff.feature_by_id[feat.ps_parent_id] or stuff.PlayerParent), not v)
							end ]]
						end
					end
				else
					if v then
						t:activate_feat_func()
					end
				end
			elseif k == "value" or k == "min" or k == "mod" or k == "max" then
				if k ~= "value" and t.type >> 5 & 1 ~= 0 then -- value_str
					error("max, min and mod are readonly for value_str features")
				end
				v = tonumber(v)

				assert(t.type >> 1 & 1 ~= 0, "feat type not supported: "..t.type) -- value_[if], value_str
				assert(v, "tried to set "..k.." property to a non-number value")

				if t.type >> 5 & 1 ~= 0 then -- value_str
					if v < 0 then
						v = 0
					elseif t.real_str_data then
						if v+1 > #t.real_str_data and #t.real_str_data ~= 0 then
							v = #t.real_str_data-1
						end
					end
				end

				if t.type >> 1 & 1 ~= 0 then
					if t.type >> 3 & 1 ~= 0 or t.type >> 5 & 1 ~= 0 then -- value_str
						v = math.floor(v)
					end

					stuff.rawset(t, "real_"..k, v)
					if t.type & 140 ~= 0 then -- i|f|slider
						if not t.real_max then
							t.real_max = 0
						end
						if not t.real_min then
							t.real_min = 0
						end
						if not t.real_mod then
							t.real_mod = 1
						end
						if not t.real_value then
							t.real_value = 0
						end

						stuff.rawset(t, "real_value", t.real_value >= t.real_max and t.real_max or t.real_value <= t.real_min and t.real_min or t.real_value)
					end

					if t["table_"..k] then
						local is_num = t.type & 140 ~= 0
						for i = 0, 31 do
							t["table_"..k][i] = v
							if is_num then
								t["table_value"][i] = t["table_value"][i] >= t["table_max"][i] and t["table_max"][i] or t["table_value"][i] <= t["table_min"][i] and t["table_min"][i] or t["table_value"][i]
							end
						end
					end
				end
			elseif k == "hidden" then
				assert(type(v) == "boolean", "hidden only accepts booleans")
				if t.real_hidden == v then
					return
				end

				--[[ if t.real_hidden ~= nil then
					func.check_scroll(t.index, (t.parent_id > 0 and t.parent or features), v)
				end ]]

				t.real_hidden = v
				if t.feats then
					for _, feat in ipairs(t.feats) do
						feat.hidden = v
					end
				end
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
			elseif k == "hint" then
				local hintTable = t.type >> 15 & 1 ~= 0 and stuff.player_feature_hints or stuff.feature_hints
				if not v then
					hintTable[t.id] = nil
					return
				end
				assert(type(v) == "string", "Feat.hint only supports strings")
				local str = cheeseUtils.wrap_text(v, stuff.menuData.fonts.hint, stuff.menuData.text_size * stuff.menuData.hint_size_modifier, stuff.menuData.width*2-scriptdraw.size_pixel_to_rel_x(25))
				hintTable[t.id] = {str = str, size = scriptdraw.get_text_size(str, 1, stuff.menuData.fonts.hint), original = v}
			else
				stuff.rawset(t, k, v)
			end
		end
	}

	stuff.playerfeatMetaTable = {
		__index = function(t, k)
			if k == "is_highlighted" then
				return t == currentMenu[stuff.scroll + stuff.scrollHiddenOffset]
			elseif k == "parent" then
				return func.get_player_feature(t.parent_id)
			elseif k == "str_data" or k == "type" or k == "id" or k == "data" or k == "hidden" then
				return stuff.rawget(t, "real_"..k)
			elseif stuff.playerSpecialValues[k] then
				if t["table_"..k:gsub("real_", "")] then
					return t["table_"..k:gsub("real_", "")][t.pid]
				end
			elseif k == "children" and t.type >> 11 & 1 ~= 0 then
				return t:get_children()
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
				if k ~= "value" and t.type >> 5 & 1 ~= 0 then
					error("max, min and mod are readonly for value_str features")
				end
				v = tonumber(v)

				assert(t.type >> 1 & 1 ~= 0, "feat type not supported")
				assert(v, "tried to set "..k.." property to a non-number value")

				if t.type >> 5 & 1 ~= 0 then
					if v < 0 then
						v = 0
					elseif t.real_str_data then
						if v+1 > #t.real_str_data and #t.real_str_data ~= 0 then
							v = #t.real_str_data-1
						end
					end
				end

				if t.type >> 1 & 1 ~= 0 then
					if t.type >> 3 & 1 ~= 0 or t.type >> 5 & 1 ~= 0 then -- value_i|str
						v = math.floor(v)
					end

					t["table_"..k][t.pid] = v
					if t.type & 140 ~= 0 then -- i|f|slider
						if not t.real_max then
							t.real_max = 0
						end
						if not t.real_min then
							t.real_min = 0
						end
						if not t.real_mod then
							t.real_mod = 1
						end
						if not t.real_value then
							t.real_value = 0
						end

						t["table_value"][t.pid] = t["table_value"][t.pid] >= t["table_max"][t.pid] and t["table_max"][t.pid] or t["table_value"][t.pid] <= t["table_min"][t.pid] and t["table_min"][t.pid] or t["table_value"][t.pid]
					end
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
		assert(self.type >> 5 & 1 ~= 0, "used get_str_data on a feature that isn't value_str")
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
			self.real_value = #self.real_str_data-1 >= 0 and #self.real_str_data-1 or 0
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
		if self.type & 1 ~= 0 then
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
		if self.on ~= nil and self.type & 2049 == 0 then -- not toggle or parent
			self.on = true
		end
		local continue = self:func(pidordata, self.data)
		while continue == HANDLER_CONTINUE do
			system.wait(0)
			continue = self:func(pidordata, self.data)
		end
		if self.on ~= nil and self.type & 2049 == 0 then -- not toggle or parent
			self.on = false
		end
	end

	function stuff.highlight_callback(self)
		local pidordata = self.pid or self.data
		self:hl_func(pidordata, self.data)
	end

	stuff.activate_feat_func = function(self)
		if not (self.thread) then
			self.thread = 0
		end
		if self.func and menu.has_thread_finished(self.thread) then
			self.thread = menu.create_thread(stuff.feature_callback, self)
		end
	end

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
			toggle = 1 << 0,
			slider = 1 << 2 | 1 << 1 | 1 << 0,
			value_i = 1 << 3 | 1 << 1 | 1 << 0,
			value_str = 1 << 5 | 1 << 1 | 1 << 0,
			value_f = 1 << 7 | 1 << 1 | 1 << 0,
			action = 1 << 9,
			action_slider = 1 << 9 | 1 << 2 | 1 << 1,
			action_value_i = 1 << 9 | 1 << 3 | 1 << 1,
			action_value_str = 1 << 9 | 1 << 5 | 1 << 1,
			action_value_f = 1 << 9 | 1 << 7 | 1 << 1,
			autoaction_slider = 1 << 10 | 1 << 2 | 1 << 1,
			autoaction_value_i = 1 << 10 | 1 << 3 | 1 << 1,
			autoaction_value_str = 1 << 10 | 1 << 5 | 1 << 1,
			autoaction_value_f = 1 << 10 | 1 << 7 | 1 << 1,
			parent = 1 << 11
		},
	}

	--Functions
	function func.add_feature(nameOfFeat, TypeOfFeat, parentOfFeat, functionCallback, highlightCallback, playerFeat)
		assert((type(nameOfFeat) == "string"), "invalid name in add_feature")
		assert((type(TypeOfFeat) == "string") and stuff.type_id.name_to_id[TypeOfFeat], "invalid type in add_feature")
		assert((type(parentOfFeat) == "number") or not parentOfFeat, "invalid parent id in add_feature")
		assert((type(functionCallback) == "function") or not functionCallback, "invalid function in add_feature")
		playerFeat = playerFeat or false
		parentOfFeat = parentOfFeat or 0
		--TypeOfFeat = TypeOfFeat:gsub("slider", "value_f")
		local currentParent = playerFeat and features["OnlinePlayers"] or features

		local hierarchy_key
		if parentOfFeat ~= 0 and parentOfFeat then
			currentParent = playerFeat and stuff.player_feature_by_id[parentOfFeat] or stuff.feature_by_id[parentOfFeat]
			if currentParent then
				assert(currentParent.type >> 11 & 1 ~= 0, "parent is not a parent feature")
				assert(currentParent.type >> 15 & 1 ~= 0 == playerFeat, "parent is not valid "..((currentParent.type >> 15 & 1 ~= 0 and not playerFeat) and "using player feature as parent for a local feature" or (currentParent.type >> 15 & 1 == 0 and playerFeat and "using local parent for player feature") or "unknown"))
			else
				error("parent does not exist")
			end
		end
		if currentParent.hierarchy_key then
			hierarchy_key = currentParent.hierarchy_key.."."..nameOfFeat:gsub("[ %.]", "_")
		else
			hierarchy_key = nameOfFeat:gsub("[ %.]", "_")
		end

		currentParent[#currentParent + 1] = {name = nameOfFeat, real_type = stuff.type_id.name_to_id[TypeOfFeat] | (playerFeat and 1 << 15 or 0), real_id = 0, --[[parent = {id = currentParent.id or 0},]] parent_id = currentParent.id or 0, playerFeat = playerFeat, index = #currentParent + 1}
		local feat = currentParent[#currentParent]
		feat.activate_feat_func = stuff.activate_feat_func
		feat.activate_hl_func = stuff.activate_hl_func
		feat.set_str_data = stuff.set_str_data
		feat.toggle = stuff.toggle
		feat.get_children = stuff.get_children
		feat.get_str_data = stuff.get_str_data
		feat.select = stuff.select
		setmetatable(feat, stuff.featMetaTable)
		feat.thread = 0
		--if feat.real_type & 1 ~= 0 or feat.real_type >> 9 & 1 ~= 0 then -- toggle
			if playerFeat then
				feat.table_on = {}
				for i = 0, 31 do
					feat.table_on[i] = feat.type >> 11 & 1 ~= 0
				end
			end
			feat.on = feat.type >> 11 & 1 ~= 0
		--end
		if feat.real_type >> 5 & 1 ~= 0 then -- value_str
			feat.real_str_data = {}
			if playerFeat then
				feat.table_value = {}
				for i = 0, 31 do
					feat.table_value[i] = 0
				end
			end
			feat.value = 0
		elseif feat.real_type >> 1 & 1 ~= 0 then --value any
			if playerFeat then
				feat.table_max = {}
				feat.table_min = {}
				feat.table_mod = {}
				feat.table_value = {}
				for i = 0, 31 do
					feat.table_max[i] = 0
					feat.table_min[i] = 0
					feat.table_mod[i] = 1
					feat.table_value[i] = 0
				end
			end
			feat.max = 0
			feat.min = 0
			feat.mod = 1
			feat.value = 0
		end
		feat.hidden = false
		feat["func"] = functionCallback
		feat["hl_func"] = highlightCallback
		if TypeOfFeat == "parent" then
			feat.child_count = 0
		end
		currentParent.child_count = 0
		for k, v in pairs(currentParent) do
			if type(k) == "number" then
				currentParent.child_count = currentParent.child_count + 1
			end
		end

		feat.hotkey = stuff.hierarchy_key_to_hotkey[hierarchy_key]
		feat.hierarchy_key = hierarchy_key
		if stuff.hotkey_feature_hierarchy_keys[hierarchy_key] then
			stuff.hotkey_feature_hierarchy_keys[hierarchy_key][#stuff.hotkey_feature_hierarchy_keys[hierarchy_key] + 1] = feat
	 	else
			stuff.hotkey_feature_hierarchy_keys[hierarchy_key] = {feat}
		end
		feat.hierarchy_id = #stuff.hotkey_feature_hierarchy_keys[hierarchy_key]

		if stuff.saved_shortcuts and stuff.saved_shortcuts[hierarchy_key] then
			func.add_shortcut(feat, stuff.saved_shortcuts[hierarchy_key])
		end

		if playerFeat then
			stuff.player_feature_by_id[#stuff.player_feature_by_id+1] = feat
			feat.real_id = #stuff.player_feature_by_id
		else
			stuff.feature_by_id[#stuff.feature_by_id+1] = feat
			feat.real_id = #stuff.feature_by_id
		end
		return feat
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
				if (v.type or 0) >> 11 & 1 ~= 0 then
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
		local hierarchy_pattern = stuff.PlayerParent.hierarchy_key..".player_"

		stuff.playerIds = {}
		for i = 0, 31 do
			stuff.playerIds[i] = func.add_feature(tostring(player.get_player_name(i)), "parent", stuff.PlayerParent.id)
			stuff.playerIds[i].pid = i
			stuff.playerIds[i].hidden = not player.is_player_valid(i)
			stuff.playerIds[i].hierarchy_key = hierarchy_pattern..i
			stuff.playerIds[i].real_type = 1 << 15 | stuff.playerIds[i].type
		end

		event.add_event_listener("player_join", function(listener)
			system.wait(100)
			stuff.playerIds[listener.player].hidden = false
			stuff.playerIds[listener.player].name = player.get_player_name(listener.player)
			func.reset_player_submenu(listener.player)
			table.sort(stuff.PlayerParent, stuff.table_sort_functions[stuff.player_submenu_sort])
		end)
		event.add_event_listener("player_leave", function(listener)
			func.reset_player_submenu(listener.player)
			if not player.is_player_valid(listener.player) then
				stuff.playerIds[listener.player].hidden = true
				stuff.playerIds[listener.player].name = "nil"
			end
			table.sort(stuff.PlayerParent, stuff.table_sort_functions[stuff.player_submenu_sort])
		end)

		return stuff.PlayerParent
	end

	function func.reset_player_submenu(pid, currentParent)
		local currentParent = currentParent or features.OnlinePlayers
		for k, v in pairs(currentParent) do
			if type(v) == "table" then
				local feat_type = v.type
				if feat_type then
					if feat_type >> 1 & 1 ~= 0 then -- toggle
						v.table_value[pid] = v.real_value
						if feat_type & 136 ~= 0 then -- value if
							v.table_min[pid] = v.real_min
							v.table_max[pid] = v.real_max
							v.table_mod[pid] = v.real_mod
						end
					end
					if feat_type & 1 ~= 0 then -- toggle
						if player.is_player_valid(pid) then
							v.feats[pid].on = v.real_on
						else
							v.feats[pid].on = false
							v.table_on[pid] = false
						end
					end
					if feat_type >> 11 & 1 ~= 0 then -- parent
						func.reset_player_submenu(pid, v)
					end
				end
			end
		end
	end
	--end of player feature functions

	function func.check_scroll(index, parent, bool)
		if index <= stuff.scroll + stuff.scrollHiddenOffset and currentMenu == parent then
			if bool then
				--stuff.scroll = stuff.scroll - 1
				--stuff.scroll = stuff.scroll > 0 and stuff.scroll or 0
				if #currentMenu - stuff.drawHiddenOffset > 1 and stuff.scroll - 1 > 0 then
					stuff.scroll = stuff.scroll - 1
					if stuff.scroll - stuff.drawScroll <= 2 and stuff.drawScroll > 0 then
						stuff.drawScroll = stuff.drawScroll - 1
					end
				end
			else
				if #currentMenu - stuff.drawHiddenOffset > 1 then
					stuff.scroll = stuff.scroll + 1
					if stuff.scroll - stuff.drawScroll >= (stuff.menuData.max_features - 1) and stuff.drawScroll < stuff.maxDrawScroll then
						stuff.drawScroll = stuff.drawScroll + 1
					end
				end
				--stuff.scroll = stuff.scroll + 1
			end
		end
	end

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
		if not feat then
			return false
		end

		stuff.hotkey_feature_hierarchy_keys[feat.hierarchy_key][feat.hierarchy_id] = nil
		func.delete_shortcut(feat.shortcut)

		if stuff.old_selected == stuff.feature_by_id[id] then
			stuff.old_selected = nil
		end
		stuff.feature_by_id[id] = nil

		if feat.thread then
			if not menu.has_thread_finished(feat.thread) then
				menu.delete_thread(feat.thread)
			end
		end
		if feat.hl_thread then
			if not menu.has_thread_finished(feat.hl_thread) then
				menu.delete_thread(feat.hl_thread)
			end
		end

		local parent
		if feat.parent_id ~= 0 or bool_ps then
			parent = bool_ps and stuff.feature_by_id[feat.ps_parent_id] or stuff.feature_by_id[feat.parent_id]
		else
			parent = features
		end

		if feat.type >> 11 & 1 ~= 0 then
			func.deleted_or_hidden_parent_check(feat)
		end

		local index = feat.index
		if not bool_ps then
			stuff.feature_hints[index] = nil
		end
		table.remove(parent, tonumber(feat.index))

		--func.check_scroll(index, parent, true)

		for i = index, #parent do
			parent[i].index = i
		end

		return true
	end

	function func.delete_player_feature(id)
		if type(id) == "table" then
			id = id.id
		end

		stuff.player_feature_hints[id] = nil

		local feat = stuff.player_feature_by_id[id]
		if not feat then
			return false
		end

		stuff.player_feature_by_id[id] = nil

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

	function func.do_key(time, key, doLoopedFunction, functionToDo)
		if cheeseUtils.get_key(key):is_down() then
			functionToDo()
			local timer = utils.time_ms() + time
			while timer > utils.time_ms() and cheeseUtils.get_key(key):is_down() do
				system.wait(0)
			end
			while timer < utils.time_ms() and cheeseUtils.get_key(key):is_down() do
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
	function func.load_sprite(path_to_file, id_table)
		--path = path or stuff.path.header
		id_table = id_table or stuff.header_ids
		path_to_file = tostring(path_to_file)
		assert(path_to_file, "invalid header path")

		--name = name:gsub("%.[a-z]+$", "")

		if not id_table[path_to_file] then
			if path_to_file:find("%.ogif") and utils.dir_exists(path_to_file:gsub("%.ogif", "")) then
				local path = path_to_file:gsub("%.ogif", "").."\\"
				local images

				for _, v in pairs(stuff.image_ext) do
					images = utils.get_all_files_in_directory(path, v)
					if images[1] then break end
				end
				if not images[1] then
					menu.notify("No frames found.", "Cheese Menu", 5, 0x0000FF)
					return
				end

				id_table[path_to_file] = {}
				for i, e in pairs(images) do
					id_table[path_to_file][i] = {}
					id_table[path_to_file][i].sprite = scriptdraw.register_sprite(path..e)
					id_table[path_to_file][i].delay = e:match("%d+_(%d+)")
				end

				id_table[path_to_file].constant_delay = utils.get_all_files_in_directory(path, "txt")[1]
				if not id_table[path_to_file].constant_delay then
					for k, v in pairs(images) do
						if not v:match("%d+_(%d+)") then
							menu.notify("FPS file not found and frames are not in format, create a txt file with the framerate of the gif.\nExample: '25 fps.txt'", "Cheese Menu", 5, 0x0000FF)
							break
						end
					end
				else
					id_table[path_to_file].constant_delay = math.floor(1000 / tonumber(id_table[path_to_file].constant_delay:match("(%d*%.*%d+)%s+fps")))
				end

			elseif utils.file_exists(path_to_file) then
				id_table[path_to_file] = scriptdraw.register_sprite(path_to_file)
			end
		end

		return id_table[path_to_file]
	end

	function func.toggle_menu(bool)
		stuff.menuData.menuToggle = bool
		if stuff.menuData.menuToggle then
			if currentMenu[stuff.scroll + stuff.scrollHiddenOffset] then
				currentMenu[stuff.scroll + stuff.scrollHiddenOffset]:activate_hl_func()
			end
		end
	end

	function func.selector(feat)
		local originalmenuToggle = stuff.menuData.menuToggle
		stuff.menuData.menuToggle = false
		if feat.str_data then
			local index, _ = cheeseUtils.selector(nil, stuff.menuData.selector_speed, feat.real_value + 1, feat.str_data)
			if index then
				feat.real_value = index - 1
			end
			if feat.type >> 10 & 1 ~= 0 then
				feat:activate_feat_func()
			end
		end
		func.toggle_menu(originalmenuToggle)
	end

	function func.rewrap_hint(hintTable, font, padding)
		hintTable.str = cheeseUtils.wrap_text(hintTable.original, font, stuff.menuData.text_size * stuff.menuData.hint_size_modifier, stuff.menuData.width*2-padding)
		hintTable.size = scriptdraw.get_text_size(hintTable.str, 1, font)
	end

	function func.rewrap_hints(font)
		local padding = scriptdraw.size_pixel_to_rel_x(25)
		for _, hintTable in pairs(stuff.feature_hints) do
			func.rewrap_hint(hintTable, font, padding)
		end
		for _, hintTable in pairs(stuff.player_feature_hints) do
			func.rewrap_hint(hintTable, font, padding)
		end
	end

	function func.set_menu_pos(x, y)
		stuff.menuData.pos_x = x or stuff.menuData.pos_x
		stuff.menuData.pos_y = y or stuff.menuData.pos_y
	end

	function func.save_settings()
		gltw.write({
			x = stuff.menuData.pos_x,
			y = stuff.menuData.pos_y,
			side_window = stuff.menuData.side_window,
			controls = stuff.controls,
			hotkey_notifications = stuff.hotkey_notifications,
			player_submenu_sort = stuff.player_submenu_sort,
			selector_speed = stuff.menuData.selector_speed
		}, "Settings", stuff.path.cheesemenu)
	end

	function func.load_settings()
		local settings = gltw.read("Settings", stuff.path.cheesemenu, nil, nil, true)
		if settings then
			stuff.menuData.pos_x = settings.x
			stuff.menuData.pos_y = settings.y
			stuff.menuData.selector_speed = settings.selector_speed
			stuff.player_submenu_sort = settings.player_submenu_sort

			for k, v in pairs(settings.side_window) do
				stuff.menuData.side_window[k] = v
			end
			for k, v in pairs(settings.hotkey_notifications) do
				stuff.hotkey_notifications[k] = v
			end
			for k, v in pairs(settings.controls) do
				stuff.controls[k] = v
				menu_configuration_features.control_features[k]:set_str_data({v})
			end
			for k, v in pairs(stuff.controls) do
				stuff.vkcontrols[k] = stuff.char_codes[v]
			end

			menu_configuration_features.menuXfeat.value = math.floor(stuff.menuData.pos_x*graphics.get_screen_width())
			menu_configuration_features.menuYfeat.value = math.floor(stuff.menuData.pos_y*graphics.get_screen_height())
			menu_configuration_features.player_submenu_sort.value = stuff.player_submenu_sort
			menu_configuration_features.player_submenu_sort:toggle()
			menu_configuration_features.side_window_offsetx.value = math.floor(stuff.menuData.side_window.offset.x*graphics.get_screen_width())
			menu_configuration_features.side_window_offsety.value = math.floor(stuff.menuData.side_window.offset.y*graphics.get_screen_height())
			menu_configuration_features.side_window_spacing.value = math.floor(stuff.menuData.side_window.spacing*graphics.get_screen_height())
			menu_configuration_features.side_window_padding.value = math.floor(stuff.menuData.side_window.padding*graphics.get_screen_width())
			menu_configuration_features.side_window_width.value = math.floor(stuff.menuData.side_window.width*graphics.get_screen_width())
			menu_configuration_features.side_window_on.on = stuff.menuData.side_window.on
			menu_configuration_features.selector_speed.value = stuff.menuData.selector_speed
		end
	end

	function func.save_ui(name)
		gltw.write(stuff.menuData, name, stuff.path.ui, {"menuToggle", "menuNav", "loaded_sprites", "files", "pos_x", "pos_y", "side_window", "selector_speed", "inputBoxOpen"})
	end

	function func.load_ui(name)
		local uiTable = gltw.read(name, stuff.path.ui, stuff.menuData, true, true)
		if not uiTable then
			return
		end
		if menu_configuration_features then
			local header, bgSprite = uiTable.header, uiTable.background_sprite and uiTable.background_sprite.sprite or nil
			if not header then
				menu_configuration_features.headerfeat.value = 0
				menu_configuration_features.headerfeat:toggle()
			end
			if not bgSprite then
				menu_configuration_features.backgroundfeat.value = 0
				menu_configuration_features.backgroundfeat:toggle()
			end

			--[[ menu_configuration_features.menuXfeat.value = math.floor(stuff.menuData.pos_x*graphics.get_screen_width())
			menu_configuration_features.menuYfeat.value = math.floor(stuff.menuData.pos_y*graphics.get_screen_height()) ]]
			menu_configuration_features.maxfeats.value = math.floor(stuff.menuData.max_features)
			menu_configuration_features.menuWidth.value = math.floor(stuff.menuData.width*graphics.get_screen_width())
			menu_configuration_features.featXfeat.value = math.floor(stuff.menuData.feature_scale.x*graphics.get_screen_width())
			menu_configuration_features.featYfeat.value = math.floor(stuff.menuData.feature_scale.y*graphics.get_screen_height())
			menu_configuration_features.feature_offset.value = math.floor(stuff.menuData.feature_offset*graphics.get_screen_height())
			menu_configuration_features.namePadding.value = math.floor(stuff.menuData.padding.name*graphics.get_screen_width())
			menu_configuration_features.parentPadding.value = math.floor(stuff.menuData.padding.parent*graphics.get_screen_width())
			menu_configuration_features.valuePadding.value = math.floor(stuff.menuData.padding.value*graphics.get_screen_width())
			menu_configuration_features.sliderPadding.value = math.floor(stuff.menuData.padding.slider*graphics.get_screen_width())
			menu_configuration_features.sliderWidth.value = math.floor(stuff.menuData.slider.width*graphics.get_screen_width())
			menu_configuration_features.sliderHeight.value = math.floor(stuff.menuData.slider.height*graphics.get_screen_height())
			menu_configuration_features.sliderheightActive.value = math.floor(stuff.menuData.slider.heightActive*graphics.get_screen_height())
			menu_configuration_features.text_size.value = stuff.menuData.text_size_modifier
			menu_configuration_features.footer_size.value = stuff.menuData.footer_size_modifier
			menu_configuration_features.hint_size.value = stuff.menuData.hint_size_modifier
			menu_configuration_features.text_y_offset.value = -math.floor(stuff.menuData.text_y_offset*graphics.get_screen_height())
			stuff.drawFeatParams.textOffset.y = stuff.menuData.text_y_offset
			menu_configuration_features.footer_y_offset.value = math.floor(stuff.menuData.footer.footer_y_offset*graphics.get_screen_height())
			menu_configuration_features.border.value = math.floor(stuff.menuData.border*graphics.get_screen_height())
			menu_configuration_features.backgroundsize.value = stuff.menuData.background_sprite.size
			menu_configuration_features.backgroundoffsetx.value = math.floor(stuff.menuData.background_sprite.offset.x*graphics.get_screen_width())
			menu_configuration_features.backgroundoffsety.value = math.floor(stuff.menuData.background_sprite.offset.y*graphics.get_screen_height())
			menu_configuration_features.footer_size.value = math.floor(stuff.menuData.footer.footer_size*graphics.get_screen_height())
			menu_configuration_features.footerPadding.value = math.floor(stuff.menuData.footer.padding*graphics.get_screen_width())
			menu_configuration_features.draw_footer.on = stuff.menuData.footer.draw_footer
			menu_configuration_features.footer_pos_related_to_background.on = stuff.menuData.footer.footer_pos_related_to_background
			--[[ menu_configuration_features.side_window_offsetx.value = math.floor(stuff.menuData.side_window.offset.x*graphics.get_screen_width())
			menu_configuration_features.side_window_offsety.value = math.floor(stuff.menuData.side_window.offset.y*graphics.get_screen_height())
			menu_configuration_features.side_window_spacing.value = math.floor(stuff.menuData.side_window.spacing*graphics.get_screen_height())
			menu_configuration_features.side_window_padding.value = math.floor(stuff.menuData.side_window.padding*graphics.get_screen_width())
			menu_configuration_features.side_window_width.value = math.floor(stuff.menuData.side_window.width*graphics.get_screen_width())
			menu_configuration_features.side_window_on.on = stuff.menuData.side_window.on ]]
			menu_configuration_features.text_font.value = stuff.menuData.fonts.text
			menu_configuration_features.footer_font.value = stuff.menuData.fonts.footer
			menu_configuration_features.hint_font.value = stuff.menuData.fonts.hint

			menu_configuration_features.hint_font:toggle()

			for k, v in pairs(stuff.menuData.color) do
				if menu_configuration_features[k] then
					if type(v) == "table" then
						menu_configuration_features[k].r.value = v.r
						menu_configuration_features[k].g.value = v.g
						menu_configuration_features[k].b.value = v.b
						menu_configuration_features[k].a.value = v.a
					else
						menu_configuration_features[k].r.value = cheeseUtils.convert_int_to_rgba(v, "r")
						menu_configuration_features[k].g.value = cheeseUtils.convert_int_to_rgba(v, "g")
						menu_configuration_features[k].b.value = cheeseUtils.convert_int_to_rgba(v, "b")
						menu_configuration_features[k].a.value = cheeseUtils.convert_int_to_rgba(v, "a")
					end
				end
			end

			for k, v in pairs(menu_configuration_features.headerfeat.str_data) do
				if v == stuff.menuData.header then
					menu_configuration_features.headerfeat.value = k - 1
				end
			end

			if uiTable.background_sprite then
				for k, v in pairs(menu_configuration_features.backgroundfeat.str_data) do
					if v == uiTable.background_sprite.sprite then
						menu_configuration_features.backgroundfeat.value = k - 1
					end
				end
			end
		end
	end

	stuff.drawFeatParams = {
		rectPos = v2(stuff.menuData.pos_x, stuff.menuData.pos_y - stuff.menuData.feature_offset/2 + stuff.menuData.border),
		textOffset = v2(stuff.menuData.feature_scale.x/2, -0.0055555555),
		colorText = stuff.menuData.color.text,
		textSize = 0,
	}
	function func.draw_feat(k, v, offset, hiddenOffset)
		--[[ stuff.drawFeatParams.rectPos.x = stuff.menuData.pos_x
		stuff.drawFeatParams.rectPos.y = stuff.menuData.pos_y - stuff.menuData.feature_offset/2 + stuff.menuData.border
		stuff.drawFeatParams.textOffset.x = stuff.menuData.feature_scale.x/2
		stuff.drawFeatParams.textSize = textSize ]]
		stuff.drawFeatParams.colorText = stuff.menuData.color.text
		stuff.drawFeatParams.bottomLeft = stuff.menuData.color.feature_bottomLeft
		stuff.drawFeatParams.topLeft = stuff.menuData.color.feature_topLeft
		stuff.drawFeatParams.topRight = stuff.menuData.color.feature_topRight
		stuff.drawFeatParams.bottomRight = stuff.menuData.color.feature_bottomRight
		local posY = (stuff.drawFeatParams.rectPos.y + (stuff.menuData.feature_offset * k))*-2+1

		local is_selected
		if stuff.scroll == k + stuff.drawScroll then
			stuff.scrollHiddenOffset = hiddenOffset or stuff.scrollHiddenOffset
			stuff.drawFeatParams.colorText = stuff.menuData.color.text_selected
			stuff.drawFeatParams.bottomLeft = stuff.menuData.color.feature_selected_bottomLeft
			stuff.drawFeatParams.topLeft = stuff.menuData.color.feature_selected_topLeft
			stuff.drawFeatParams.topRight = stuff.menuData.color.feature_selected_topRight
			stuff.drawFeatParams.bottomRight = stuff.menuData.color.feature_selected_bottomRight
			is_selected = true
		end
		if offset == 0 then
			local memv2 = cheeseUtils.memoize.v2
			local posX = stuff.drawFeatParams.rectPos.x*2-1
			--[[ scriptdraw.draw_rect(
				cheeseUtils.memoize.v2(posX, posY),
				cheeseUtils.memoize.v2(stuff.menuData.feature_scale.x*2, stuff.menuData.feature_scale.y*2),
				cheeseUtils.convert_rgba_to_int(stuff.drawFeatParams.colorFeature.r, stuff.drawFeatParams.colorFeature.g, stuff.drawFeatParams.colorFeature.b, stuff.drawFeatParams.colorFeature.a)
			) ]]
			local Left = posX - stuff.menuData.feature_scale.x
			local Right = posX + stuff.menuData.feature_scale.x
			local Top = posY + stuff.menuData.feature_scale.y
			local Bottom = posY - stuff.menuData.feature_scale.y
			scriptdraw.draw_rect_ext(
				memv2(Left, Bottom),
				memv2(Left, Top),
				memv2(Right, Top),
				memv2(Right, Bottom),
				cheeseUtils.convert_rgba_to_int(stuff.drawFeatParams.bottomLeft.r, stuff.drawFeatParams.bottomLeft.g, stuff.drawFeatParams.bottomLeft.b, stuff.drawFeatParams.bottomLeft.a),
				cheeseUtils.convert_rgba_to_int(stuff.drawFeatParams.topLeft.r, stuff.drawFeatParams.topLeft.g, stuff.drawFeatParams.topLeft.b, stuff.drawFeatParams.topLeft.a),
				cheeseUtils.convert_rgba_to_int(stuff.drawFeatParams.topRight.r, stuff.drawFeatParams.topRight.g, stuff.drawFeatParams.topRight.b, stuff.drawFeatParams.topRight.a),
				cheeseUtils.convert_rgba_to_int(stuff.drawFeatParams.bottomRight.r, stuff.drawFeatParams.bottomRight.g, stuff.drawFeatParams.bottomRight.b, stuff.drawFeatParams.bottomRight.a)
			)
		end

		local font = stuff.menuData.fonts.text
		if v.type & 1 == 0 then
			scriptdraw.draw_text(
				v["name"],
				cheeseUtils.memoize.v2((stuff.drawFeatParams.rectPos.x - (stuff.drawFeatParams.textOffset.x - stuff.menuData.padding.name))*2-1, (stuff.drawFeatParams.rectPos.y + stuff.drawFeatParams.textOffset.y + (stuff.menuData.feature_offset * k))*-2+1),
				cheeseUtils.memoize.v2(10, 10),
				stuff.drawFeatParams.textSize,
				cheeseUtils.convert_rgba_to_int(stuff.drawFeatParams.colorText.r, stuff.drawFeatParams.colorText.g, stuff.drawFeatParams.colorText.b, stuff.drawFeatParams.colorText.a),
				0, font
			)
			if v.type >> 11 & 1 ~= 0 then
				scriptdraw.draw_text(
					">>",
					cheeseUtils.memoize.v2((stuff.drawFeatParams.rectPos.x + (stuff.drawFeatParams.textOffset.x - stuff.menuData.padding.parent))*2-1, (stuff.drawFeatParams.rectPos.y + stuff.drawFeatParams.textOffset.y + (stuff.menuData.feature_offset * k))*-2+1),
					cheeseUtils.memoize.v2(10, 10),
					stuff.drawFeatParams.textSize,
					cheeseUtils.convert_rgba_to_int(stuff.drawFeatParams.colorText.r, stuff.drawFeatParams.colorText.g, stuff.drawFeatParams.colorText.b, stuff.drawFeatParams.colorText.a),
					16, font
				)
			end
		elseif v.type & 1 ~= 0 then -- toggle
			cheeseUtils.draw_outline(
				cheeseUtils.memoize.v2((stuff.drawFeatParams.rectPos.x - (stuff.drawFeatParams.textOffset.x - stuff.menuData.padding.name) + 0.00390625)*2-1, posY),
				cheeseUtils.memoize.v2(0.015625, 0.0277777777778),
				cheeseUtils.convert_rgba_to_int(stuff.drawFeatParams.colorText.r, stuff.drawFeatParams.colorText.g, stuff.drawFeatParams.colorText.b, stuff.drawFeatParams.colorText.a),
				2
			)
			if v.real_on then
				scriptdraw.draw_rect(
					cheeseUtils.memoize.v2((stuff.drawFeatParams.rectPos.x - (stuff.drawFeatParams.textOffset.x - stuff.menuData.padding.name) + 0.00390625)*2-1, posY),
					cheeseUtils.memoize.v2(0.0140625, 0.025),
					cheeseUtils.convert_rgba_to_int(stuff.drawFeatParams.colorText.r, stuff.drawFeatParams.colorText.g, stuff.drawFeatParams.colorText.b, stuff.drawFeatParams.colorText.a)
				)
			end

			scriptdraw.draw_text(
				v.name,
				cheeseUtils.memoize.v2((stuff.drawFeatParams.rectPos.x - (stuff.drawFeatParams.textOffset.x - stuff.menuData.padding.name) + 0.011328125)*2-1, (stuff.drawFeatParams.rectPos.y + stuff.drawFeatParams.textOffset.y + (stuff.menuData.feature_offset * k))*-2+1),
				cheeseUtils.memoize.v2(10, 10),
				stuff.drawFeatParams.textSize,
				cheeseUtils.convert_rgba_to_int(stuff.drawFeatParams.colorText.r, stuff.drawFeatParams.colorText.g, stuff.drawFeatParams.colorText.b, stuff.drawFeatParams.colorText.a),
				0, font
			)
		end

		if v.type >> 1 & 1 ~= 0 then -- value_i_f_str
			local rounded_value = v.str_data and v.str_data[v.real_value + 1] or v.real_value
			if v.type >> 7 & 1 ~= 0 or v.type >> 2 & 1 ~= 0 then
				rounded_value = (rounded_value * 10000) + 0.5
				rounded_value = math.floor(rounded_value)
				rounded_value = rounded_value / 10000
			end
			if v.type >> 2 & 1 ~= 0 then
				cheeseUtils.draw_slider(
					cheeseUtils.memoize.v2(
						(stuff.drawFeatParams.rectPos.x + stuff.menuData.feature_scale.x/2 - stuff.menuData.slider.width/4 - stuff.menuData.padding.slider)*2-1,
						posY
					),
					cheeseUtils.memoize.v2(stuff.menuData.slider.width, is_selected and stuff.menuData.slider.heightActive or stuff.menuData.slider.height),
					v.min, v.max, v.value,
					is_selected and cheeseUtils.convert_rgba_to_int(stuff.menuData.color.slider_selectedBackground) or cheeseUtils.convert_rgba_to_int(stuff.menuData.color.slider_background),
					is_selected and cheeseUtils.convert_rgba_to_int(stuff.menuData.color.slider_selectedActive) or cheeseUtils.convert_rgba_to_int(stuff.menuData.color.slider_active),
					is_selected and cheeseUtils.convert_rgba_to_int(stuff.menuData.color.slider_text) or 0,
					is_selected
				)
			else
				local value_str = "< "..tostring(rounded_value).." >"
				local original_size
				if v.str_data then
					local pixel_size = scriptdraw.get_text_size(value_str, 1, font).x
					local screenWidth = graphics.get_screen_width()
					if pixel_size/screenWidth > 370/screenWidth then
						original_size = stuff.drawFeatParams.textSize
						stuff.drawFeatParams.textSize = stuff.drawFeatParams.textSize * (370 / pixel_size * 0.8)
						stuff.drawFeatParams.textSize = math.min(stuff.drawFeatParams.textSize + 0.2, original_size)
					end
				end

				scriptdraw.draw_text(
					value_str,
					cheeseUtils.memoize.v2((stuff.drawFeatParams.rectPos.x + (stuff.drawFeatParams.textOffset.x - stuff.menuData.padding.value) - scriptdraw.size_pixel_to_rel_x(scriptdraw.get_text_size(value_str, stuff.drawFeatParams.textSize, font).x)/4)*2-1, (stuff.drawFeatParams.rectPos.y + stuff.drawFeatParams.textOffset.y + (stuff.menuData.feature_offset * k))*-2+1),
					cheeseUtils.memoize.v2(10, 10),
					stuff.drawFeatParams.textSize,
					cheeseUtils.convert_rgba_to_int(stuff.drawFeatParams.colorText.r, stuff.drawFeatParams.colorText.g, stuff.drawFeatParams.colorText.b, stuff.drawFeatParams.colorText.a),
					0, font
				)

				stuff.drawFeatParams.textSize = original_size or stuff.drawFeatParams.textSize
			end
		end
	end

	stuff.draw_current_menu = {frameCounter = 1, time = utils.time_ms() + 33, currentSprite = stuff.menuData.header}
	function func.draw_current_menu()
		local sprite = func.load_sprite(stuff.path.header..(stuff.menuData.header or ""))
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
				if v.hidden or (v.type >> 11 & 1 ~= 0 and not v.on) then
					stuff.drawHiddenOffset = stuff.drawHiddenOffset + 1
				end
			end
		end
		local background_sprite_path = stuff.path.background..(stuff.menuData.background_sprite.sprite or "")
		if stuff.menuData.background_sprite.sprite and func.load_sprite(background_sprite_path) and stuff.menuData.color.sprite_background.a > 0 then
			scriptdraw.draw_sprite(
				func.load_sprite(background_sprite_path),
				cheeseUtils.memoize.v2((stuff.menuData.pos_x + stuff.menuData.background_sprite.offset.x)*2-1, (stuff.menuData.pos_y+stuff.menuData.background_sprite.offset.y+stuff.menuData.height/2+0.01458)*-2+1),
				stuff.menuData.background_sprite.size,
				0,
				cheeseUtils.convert_rgba_to_int(stuff.menuData.color.sprite_background.r, stuff.menuData.color.sprite_background.g, stuff.menuData.color.sprite_background.b, stuff.menuData.color.sprite_background.a)
			)
		end
		if stuff.menuData.color.background.a > 0 then
			scriptdraw.draw_rect(
				cheeseUtils.memoize.v2(stuff.menuData.pos_x*2-1, (stuff.menuData.pos_y+stuff.menuData.border+stuff.menuData.height/2)*-2+1),
				cheeseUtils.memoize.v2(stuff.menuData.width*2, stuff.menuData.height*2),
				cheeseUtils.convert_rgba_to_int(stuff.menuData.color.background.r, stuff.menuData.color.background.g, stuff.menuData.color.background.b, stuff.menuData.color.background.a)
			)
		end
		if #currentMenu - stuff.drawHiddenOffset >= stuff.menuData.max_features  then
			stuff.maxDrawScroll = #currentMenu - stuff.drawHiddenOffset - stuff.menuData.max_features
		else
			stuff.maxDrawScroll = 0
		end
		if stuff.drawScroll > stuff.maxDrawScroll then
			stuff.drawScroll = stuff.maxDrawScroll
		end
		if stuff.scroll > #currentMenu - stuff.drawHiddenOffset then
			stuff.scroll = #currentMenu - stuff.drawHiddenOffset
		elseif stuff.scroll < 1 and #currentMenu > 0 then
			stuff.scroll = 1
		end

		-- header border
		scriptdraw.draw_rect(cheeseUtils.memoize.v2(stuff.menuData.pos_x*2-1, (stuff.menuData.pos_y + stuff.menuData.border/2)*-2+1), cheeseUtils.memoize.v2(stuff.menuData.width*2, stuff.menuData.border*2), cheeseUtils.convert_rgba_to_int(stuff.menuData.color.border.r, stuff.menuData.color.border.g, stuff.menuData.color.border.b, stuff.menuData.color.border.a))

		local hiddenOffset = 0
		local drawnfeats = 0
		stuff.menuData.text_size = (((graphics.get_screen_width()*graphics.get_screen_height())/3686400)*0.45+0.25) -- * stuff.menuData.text_size_modifier

		stuff.drawFeatParams.rectPos.x = stuff.menuData.pos_x
		stuff.drawFeatParams.rectPos.y = stuff.menuData.pos_y - stuff.menuData.feature_offset/2 + stuff.menuData.border
		stuff.drawFeatParams.textOffset.x = stuff.menuData.feature_scale.x/2
		stuff.drawFeatParams.colorText = stuff.menuData.color.text
		stuff.drawFeatParams.colorFeature = stuff.menuData.color.feature
		stuff.drawFeatParams.textSize = stuff.menuData.text_size * stuff.menuData.text_size_modifier

		for k, v in ipairs(currentMenu) do
			if type(k) == "number" then
				if v.hidden or (v.type >> 11 & 1 ~= 0 and not v.on) then
					hiddenOffset = hiddenOffset + 1
				elseif k <= stuff.drawScroll + hiddenOffset + stuff.menuData.max_features and k >= stuff.drawScroll + hiddenOffset + 1 then
					func.draw_feat(k - stuff.drawScroll - hiddenOffset, v, 0, hiddenOffset)
					drawnfeats = drawnfeats + 1
				end
			end
		end

		if stuff.menuData.footer.draw_footer then
			-- footer border
			local footer_border_y_pos
			if stuff.menuData.footer.footer_pos_related_to_background then
				footer_border_y_pos = (stuff.menuData.pos_y + stuff.menuData.height + stuff.menuData.border*1.5)*-2+1
			else
				footer_border_y_pos = (stuff.menuData.pos_y + (drawnfeats*stuff.menuData.feature_offset) + stuff.menuData.border*1.5)*-2+1
			end
			scriptdraw.draw_rect(cheeseUtils.memoize.v2(stuff.menuData.pos_x*2-1, footer_border_y_pos), cheeseUtils.memoize.v2(stuff.menuData.width*2, stuff.menuData.border*2), cheeseUtils.convert_rgba_to_int(stuff.menuData.color.border.r, stuff.menuData.color.border.g, stuff.menuData.color.border.b, stuff.menuData.color.border.a))

			-- footer and text/scroll
			local footerColor = cheeseUtils.convert_rgba_to_int(stuff.menuData.color.footer.r, stuff.menuData.color.footer.g, stuff.menuData.color.footer.b, stuff.menuData.color.footer.a)
			local footer_y_pos
			if stuff.menuData.footer.footer_pos_related_to_background then
				footer_y_pos = (stuff.menuData.pos_y + stuff.menuData.height + stuff.menuData.border*2 + stuff.menuData.footer.footer_size/2)*-2+1
			else
				footer_y_pos = (stuff.menuData.pos_y + (drawnfeats*stuff.menuData.feature_offset) + stuff.menuData.border*2 + stuff.menuData.footer.footer_size/2)*-2+1
			end
			scriptdraw.draw_rect(cheeseUtils.memoize.v2(stuff.menuData.pos_x*2-1, footer_y_pos), cheeseUtils.memoize.v2(stuff.menuData.width*2, stuff.menuData.footer.footer_size*2), footerColor)

			local footerTextColor = cheeseUtils.convert_rgba_to_int(stuff.menuData.color.footer_text.r, stuff.menuData.color.footer_text.g, stuff.menuData.color.footer_text.b, stuff.menuData.color.footer_text.a)
			local feat = currentMenu[stuff.scroll + stuff.scrollHiddenOffset]
			local featHint = feat and (feat.type >> 15 & 1 ~= 0 and stuff.player_feature_hints[feat.id] or stuff.feature_hints[feat.id])
			if featHint then
				local padding = scriptdraw.size_pixel_to_rel_y(5)
				local hintStrSize = scriptdraw.size_pixel_to_rel_y(featHint.size.y) * (stuff.menuData.text_size * stuff.menuData.hint_size_modifier)
				local posY = footer_y_pos - stuff.menuData.border*2 - stuff.menuData.footer.footer_size - padding
				local textY = posY - padding
				posY = posY - hintStrSize/2

				local rectHeight = hintStrSize+padding*4
				--scriptdraw.draw_rect(cheeseUtils.memoize.v2(stuff.menuData.pos_x*2-1, posY+rectHalfHeight/2), cheeseUtils.memoize.v2(stuff.menuData.width*2, rectHalfHeight), cheeseUtils.convert_rgba_to_int(stuff.menuData.color.footer.r, stuff.menuData.color.footer.g, stuff.menuData.color.footer.b, stuff.menuData.color.footer.a))
				cheeseUtils.draw_rect_ext_wh(cheeseUtils.memoize.v2(stuff.menuData.pos_x*2-1, posY-padding), cheeseUtils.memoize.v2(stuff.menuData.width*2, rectHeight), (footerColor & 0xffffff) | 50 << 24, footerColor, footerColor, (footerColor & 0xffffff) | 50 << 24)
				scriptdraw.draw_text(
					featHint.str,
					cheeseUtils.memoize.v2(stuff.menuData.pos_x*2-1 - stuff.menuData.width + padding, textY),
					cheeseUtils.memoize.v2(stuff.menuData.width+padding*2, 2),
					stuff.menuData.text_size * stuff.menuData.hint_size_modifier,
					footerTextColor,
					0,
					stuff.menuData.fonts.hint
				)
			end

			local footer_size = stuff.menuData.text_size * stuff.menuData.footer_size_modifier
			local text_y_pos = footer_y_pos + 0.011111111 + stuff.menuData.footer.footer_y_offset
			scriptdraw.draw_text(
				tostring(stuff.menuData.footer.footer_text),
				cheeseUtils.memoize.v2((stuff.menuData.pos_x - stuff.menuData.width/2 + stuff.menuData.footer.padding)*2-1, text_y_pos),
				cheeseUtils.memoize.v2(2, 2),
				footer_size,
				footerTextColor,
				0,
				stuff.menuData.fonts.footer
			)

			scriptdraw.draw_text(
				tostring(stuff.scroll.." / "..(#currentMenu - stuff.drawHiddenOffset)),
				cheeseUtils.memoize.v2((stuff.menuData.pos_x + stuff.menuData.width/2 - stuff.menuData.footer.padding)*2-1, text_y_pos),
				cheeseUtils.memoize.v2(2, 2),
				footer_size,
				footerTextColor,
				16,
				stuff.menuData.fonts.footer
			)
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
			local size = ((2.56 * stuff.menuData.width) * (1000 / scriptdraw.get_sprite_size(sprite).x)) / (2560 / graphics.get_screen_width())
			scriptdraw.draw_sprite(sprite, cheeseUtils.memoize.v2(stuff.menuData.pos_x * 2 - 1, ((stuff.menuData.pos_y+stuff.menuData.height/2) - (stuff.menuData.height/2 + ((scriptdraw.get_sprite_size(sprite).y*size)/2)/graphics.get_screen_height()))*-2+1), size, 0, stuff.menuData.color.sprite)
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
			if cheeseUtils.get_key(0x1B):is_down() then
				return "escaped"
			end
			for k, v in pairs(stuff.char_codes) do
				if cheeseUtils.get_key(v):is_down() then
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
			while cheeseUtils.get_key(current_key):is_down() do
				for k, v in pairs(stuff.char_codes) do
					if cheeseUtils.get_key(v):is_down() and not excludedkeys[v] and v ~= 0xA0 and v ~= 0xA1 and v ~= 0xA2 and v ~= 0xA3 and v ~= 0xA4 and v ~= 0xA5 then
						excludedkeys[v] = true
						keyTable[#keyTable + 1] = k
						vkTable[#vkTable+1] = v
					end
				end
				system.wait(0)
			end

			while not cheeseUtils.get_key(0x1B):is_down() and not cheeseUtils.get_key(0x0D):is_down() do
				for k, v in pairs(stuff.char_codes) do
					if cheeseUtils.get_key(v):is_down() then
						return false
					end
				end
				system.wait(0)
			end

			return cheeseUtils.get_key(0x0D):is_down() or "escaped"
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

		while cheeseUtils.get_key(stuff.vkcontrols.setHotkey):is_down() do
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
		while cheeseUtils.get_key(0x0D):is_down() or cheeseUtils.get_key(0x1B):is_down() do -- enter and esc
			controls.disable_control_action(0, 200, true)
			system.wait(0)
		end
		controls.disable_control_action(0, 200, true)
		func.toggle_menu(true)
		return response ~= "escaped" and response
	end

	-- Shortcuts
	do
		local shortcut_callback = function(button)
			if cheeseUtils.get_key(stuff.vkcontrols.specialKey):is_down() then
				local pos = cheeseUtils.mouse.enable()
				while controls.is_disabled_control_pressed(0, 142) do
					for _, shortcut in pairs(stuff.shortcuts) do
						shortcut:update(true)
					end
					cheeseUtils.mouse.enable(true)
					cheeseUtils.draw_outline(pos, button.size, 0xFFFFFFFF, 4)
					system.wait(0)
				end
				button:set_pos(pos)
				func.save_shortcuts()
				return
			end
			if button.data.type & 1 ~= 0 then
				button.data.on = not button.data.on
				button.text = button.data.name..": "..(button.data.on and "ON" or "OFF")
				return
			end
			button.data:activate_feat_func()
		end
		stuff.shortcuts = {}
		function func.add_shortcut(feat, pos)
			if not feat or feat.type >> 11 & 1 ~= 0 then return end

			local is_toggle = feat.type & 1 ~= 0

			local bg = cheeseUtils.convert_rgba_to_int(stuff.menuData.color.shortcut_background)
			local text = cheeseUtils.convert_rgba_to_int(stuff.menuData.color.shortcut_text)
			local button = cheeseUtils.mouse.button(feat.name..(is_toggle and ": OFF" or ""), pos or v2(), bg, text, text, bg, stuff.menuData.fonts.text, stuff.menuData.text_size*stuff.menuData.text_size_modifier, nil, shortcut_callback)
			button.data = feat

			if is_toggle and feat.on then
				button.text = feat.name..": "..(feat.on and "ON" or "OFF")
			end

			stuff.shortcuts[#stuff.shortcuts+1] = button
			feat.shortcut = #stuff.shortcuts
		end

		function func.delete_shortcut(id, delete_saved)
			local button = id and stuff.shortcuts[id]
			if not button then return end

			if delete_saved then
				stuff.saved_shortcuts[button.data.hierarchy_key] = nil
			end

			button.data.shortcut = nil
			stuff.shortcuts[id] = nil
		end

		function func.save_shortcuts()
			local shortcuts = {}
			for hierarchy_key, pos in pairs(stuff.saved_shortcuts) do
				shortcuts[hierarchy_key] = pos
			end
			for _, button in pairs(stuff.shortcuts) do
				shortcuts[button.data.hierarchy_key] = button.pos
			end
			stuff.saved_shortcuts = shortcuts
			gltw.write(shortcuts, "shortcuts", stuff.path.hotkeys)
		end
	end

	--End of functions

	--threads
	menu.create_thread(function()
		while true do
			stuff.menuData.menuNav = native.call(0x5FCF4D7069B09026):__tointeger() ~= 1 and not (stuff.menuData.inputBoxOpen or input.is_open() --[[or console.on]])
			if stuff.menuData.menuNav then
				func.do_key(500, stuff.vkcontrols.open, false, function() -- F4
					func.toggle_menu(not stuff.menuData.menuToggle)
				end)
			end
			if currentMenu.hidden or not currentMenu then
				currentMenu = stuff.previousMenus[#stuff.previousMenus].menu
				stuff.scroll = stuff.previousMenus[#stuff.previousMenus].scroll
				stuff.drawScroll = stuff.previousMenus[#stuff.previousMenus].drawScroll
				stuff.scrollHiddenOffset = stuff.previousMenus[#stuff.previousMenus].scrollHiddenOffset
				stuff.previousMenus[#stuff.previousMenus] = nil
			end
			local pid = player.player_id()
			stuff.playerIds[pid].name = player.get_player_name(pid).." [Y]"
			if stuff.playerIds[pid].hidden then
				stuff.playerIds[pid].hidden = false
				func.reset_player_submenu(pid)
			end
			system.wait(0)
		end
	end, nil)
	menu.create_thread(function()
		local selector_table = {"Hotkey", "On Screen Shortcut"}
		local choice_table = {"Set", "Delete", "Reveal"}
		while true do
			system.wait(0)
			if stuff.menuData.menuToggle and stuff.menuData.menuNav then
				func.do_key(500, stuff.vkcontrols.setHotkey, false, function() -- F11
					func.toggle_menu(false)
					local index = cheeseUtils.selector(nil, stuff.menuData.selector_speed, 1, selector_table)
					if index then
						local choice = cheeseUtils.selector(nil, stuff.menuData.selector_speed, 1, choice_table)
						local feat = currentMenu[stuff.scroll + stuff.scrollHiddenOffset]
						if index == 1 then
							if --[[cheeseUtils.get_key(0x10):is_down()]] choice == 2 and stuff.hotkeys[feat.hotkey] then
								stuff.hotkeys[feat.hotkey][feat.hierarchy_key] = nil
								if not next(stuff.hotkeys[feat.hotkey]) then
									stuff.hotkeys[feat.hotkey] = nil
								end
								feat.hotkey = nil
								gltw.write(stuff.hotkeys, "hotkeys", stuff.path.hotkeys, nil, true)
								menu.notify("Removed "..feat.name.."'s hotkey")
							elseif --[[cheeseUtils.get_key(0x11):is_down()]] choice == 3 then
								menu.notify(feat.name.."'s hotkey is "..(feat.hotkey or "none"))
							elseif choice == 1 then -- not cheeseUtils.get_key(0x10):is_down() and not cheeseUtils.get_key(0x11):is_down() then
								if stuff.hotkeys[feat.hotkey] then
									stuff.hotkeys[feat.hotkey][feat.hierarchy_key] = nil
								end
								if func.start_hotkey_process(feat) then
									menu.notify("Set "..feat.name.."'s hotkey to "..feat.hotkey)
								end
							end
						elseif index == 2 then
							if choice == 1 then
								func.add_shortcut(feat)
							elseif choice == 2 then
								func.delete_shortcut(feat.shortcut, true)
							end
							func.save_shortcuts()
						end
					end
					func.toggle_menu(true)
				end)
			end
			local is_reveal_down = cheeseUtils.get_key(stuff.vkcontrols.revealMouse):is_down()
			for _, shortcut in pairs(stuff.shortcuts) do
				shortcut:update(not is_reveal_down)
			end
			if is_reveal_down then
				cheeseUtils.mouse.enable(true)
			end
		end
	end,nil)
	menu.create_thread(function()
		while true do
			system.wait(0)
			if stuff.menuData.menuToggle and stuff.menuData.menuNav then
				func.do_key(500, stuff.vkcontrols.down, true, function() -- downKey
					--[[ local old_scroll = stuff.scroll + stuff.scrollHiddenOffset ]]
					if stuff.scroll + stuff.drawHiddenOffset >= #currentMenu and #currentMenu - stuff.drawHiddenOffset > 1 then
						stuff.scroll = 1
						stuff.drawScroll = 0
					elseif #currentMenu - stuff.drawHiddenOffset > 1 then
						stuff.scroll = stuff.scroll + 1
						if stuff.scroll - stuff.drawScroll >= (stuff.menuData.max_features - 1) and stuff.drawScroll < stuff.maxDrawScroll then
							stuff.drawScroll = stuff.drawScroll + 1
						end
					end
					--[[ if old_scroll ~= (stuff.scroll + stuff.scrollHiddenOffset) then
						currentMenu[old_scroll]:activate_hl_func()
						if currentMenu[stuff.scroll + stuff.scrollHiddenOffset] then
							currentMenu[stuff.scroll + stuff.scrollHiddenOffset]:activate_hl_func()
						end
					end ]]
				end)
			end
		end
	end, nil)
	menu.create_thread(function()
		while true do
			system.wait(0)
			if stuff.menuData.menuToggle and stuff.menuData.menuNav then
				func.do_key(500, stuff.vkcontrols.up, true, function() -- upKey
					--[[ local old_scroll = stuff.scroll + stuff.scrollHiddenOffset ]]
					if stuff.scroll <= 1 and #currentMenu - stuff.drawHiddenOffset > 1 then
						stuff.scroll = #currentMenu
						stuff.drawScroll = stuff.maxDrawScroll
					elseif #currentMenu - stuff.drawHiddenOffset > 1 then
						stuff.scroll = stuff.scroll - 1
						if stuff.scroll - stuff.drawScroll <= 2 and stuff.drawScroll > 0 then
							stuff.drawScroll = stuff.drawScroll - 1
						end
					end
					--[[ if old_scroll ~= (stuff.scroll + stuff.scrollHiddenOffset) then
						currentMenu[old_scroll]:activate_hl_func()
						if currentMenu[stuff.scroll + stuff.scrollHiddenOffset] then
							currentMenu[stuff.scroll + stuff.scrollHiddenOffset]:activate_hl_func()
						end
					end ]]
				end)
			end
		end
	end,nil)
	menu.create_thread(function()
		while true do
			system.wait(0)
			if stuff.menuData.menuToggle and stuff.menuData.menuNav then
				func.do_key(500, stuff.vkcontrols.select, true, function() --enter
					local feat = currentMenu[stuff.scroll + stuff.scrollHiddenOffset]
					if feat then
						if cheeseUtils.get_key(stuff.vkcontrols.specialKey):is_down() and feat.type >> 5 & 1 ~= 0 then
							menu.create_thread(func.selector, feat)
						elseif feat.type >> 11 & 1 ~= 0 and not feat.hidden then
							--feat:activate_hl_func()
							stuff.previousMenus[#stuff.previousMenus + 1] = {menu = currentMenu, scroll = stuff.scroll, drawScroll = stuff.drawScroll, scrollHiddenOffset = stuff.scrollHiddenOffset}
							currentMenu = feat
							currentMenu:activate_feat_func()
							stuff.scroll = 1
							system.wait(0)
							stuff.drawScroll = 0
							stuff.scrollHiddenOffset = 0
							--[[ if feat then
								feat:activate_hl_func()
							end ]]
							while cheeseUtils.get_key(stuff.vkcontrols.select):is_down() do
								system.wait(0)
							end
						elseif feat.type & 1536 ~= 0 and not feat.hidden then
							feat:activate_feat_func()
						elseif feat.type & 1 ~= 0 and not feat.hidden then
							feat.real_on = not feat.real_on
							feat:activate_feat_func()
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
			if stuff.menuData.menuToggle and stuff.menuData.menuNav then
				func.do_key(500, stuff.vkcontrols.back, false, function() --backspace
					if stuff.previousMenus[#stuff.previousMenus] then
						--[[ if currentMenu[stuff.scroll + stuff.scrollHiddenOffset] then
							currentMenu[stuff.scroll + stuff.scrollHiddenOffset]:activate_hl_func()
						end ]]
						currentMenu = stuff.previousMenus[#stuff.previousMenus].menu
						stuff.scroll = stuff.previousMenus[#stuff.previousMenus].scroll
						stuff.drawScroll = stuff.previousMenus[#stuff.previousMenus].drawScroll
						stuff.scrollHiddenOffset = stuff.previousMenus[#stuff.previousMenus].scrollHiddenOffset
						stuff.previousMenus[#stuff.previousMenus] = nil
						--currentMenu[stuff.scroll + stuff.scrollHiddenOffset]:activate_hl_func()
					end
				end)
			end
		end
	end, nil)
	menu.create_thread(function()
		while true do
			system.wait(0)
			if stuff.menuData.menuToggle and stuff.menuData.menuNav then
				func.do_key(500, stuff.vkcontrols.left, true, function() -- left
					local feat = currentMenu[stuff.scroll + stuff.scrollHiddenOffset]
					if feat then
						if feat.value then
							if feat.str_data then
								if feat.value <= 0 then
									feat.value = #feat.str_data - 1
								else
									feat.value = feat.value - 1
								end
							else
								if tonumber(feat.value) <= feat.min and feat.type >> 2 & 1 == 0 then
									feat.value = feat.max
								else
									feat.value = tonumber(feat.value) - feat.mod
								end
							end
						end
						if feat.type then
							if feat.type >> 10 & 1 ~= 0 or (feat.type & 3 == 3 and feat.on) then
								feat:activate_feat_func()
							end
						end
					end
				end)
			end
		end
	end, nil)
	menu.create_thread(function()
		while true do
			if stuff.menuData.menuToggle and stuff.menuData.menuNav then
				func.do_key(500, stuff.vkcontrols.right, true, function() -- right
					local feat = currentMenu[stuff.scroll + stuff.scrollHiddenOffset]
					if feat then
						if feat.value then
							if feat.str_data then
								if tonumber(feat.value) >= tonumber(#feat.str_data) - 1 then
									feat.value = 0
								else
									feat.value = feat.value + 1
								end
							else
								if tonumber(feat.value) >= feat.max and feat.type >> 2 & 1 == 0 then
									feat.value = feat.min
								else
									feat.value = tonumber(feat.value) + feat.mod
								end
							end
						end
						if feat.type then
							if feat.type >> 10 & 1 ~= 0 or (feat.type & 3 == 3 and feat.on) then
								feat:activate_feat_func()
							end
						end
					end
				end)
			end
			system.wait(0)
		end
	end, nil)

	menu.create_thread(function()
		local side_window_pos = v2((stuff.menuData.pos_x + stuff.menuData.width + stuff.menuData.side_window.offset.x)*2-1, (stuff.menuData.pos_y + stuff.menuData.side_window.offset.y)*-2+1)
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
						side_window_pos.x, side_window_pos.y = (stuff.menuData.pos_x + stuff.menuData.width + stuff.menuData.side_window.offset.x)*2-1, (stuff.menuData.pos_y + stuff.menuData.side_window.offset.y)*-2+1
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
							cheeseUtils.convert_rgba_to_int(stuff.menuData.color.side_window_background.r, stuff.menuData.color.side_window_background.g, stuff.menuData.color.side_window_background.b, stuff.menuData.color.side_window_background.a),
							stuff.menuData.side_window.width, stuff.menuData.side_window.spacing, stuff.menuData.side_window.padding,
							cheeseUtils.convert_rgba_to_int(stuff.menuData.color.side_window_text.r, stuff.menuData.color.side_window_text.g, stuff.menuData.color.side_window_text.b, stuff.menuData.color.side_window_text.a)
						)
					end
				end
				if stuff.old_selected ~= currentMenu[stuff.scroll + stuff.scrollHiddenOffset] then
					if type(stuff.old_selected) == "table" then
						stuff.old_selected:activate_hl_func()
					end
					if currentMenu[stuff.scroll + stuff.scrollHiddenOffset] then
						currentMenu[stuff.scroll + stuff.scrollHiddenOffset]:activate_hl_func()
					end
					stuff.old_selected = currentMenu[stuff.scroll + stuff.scrollHiddenOffset]
				end
				controls.disable_control_action(0, 172, true)
				controls.disable_control_action(0, 27, true)
			else
				system.wait(0)
			end
		end
	end, nil)


	--Hotkey thread
	menu.create_thread(function()
		while true do
			if stuff.menuData.menuNav then
				for k, v in pairs(stuff.hotkeys) do
					local hotkey = cheeseUtils.get_key(table.unpack(stuff.hotkeys_to_vk[k]))
					if hotkey:is_down() and (not (cheeseUtils.get_key(0x10):is_down() or cheeseUtils.get_key(0x11):is_down() or cheeseUtils.get_key(0x12):is_down()) or not (k:match("NOMOD"))) and utils.time_ms() > stuff.hotkey_cooldowns[k] then
						for k, v in pairs(stuff.hotkeys[k]) do
							if stuff.hotkey_feature_hierarchy_keys[k] then
								for k, v in pairs(stuff.hotkey_feature_hierarchy_keys[k]) do
									if v.type & 1 ~= 0 then
										v.on = not v.on
										if stuff.hotkey_notifications.toggle then
											menu.notify("Turned "..v.name.." "..(v.on and "on" or "off"), "Cheese Menu", 3, cheeseUtils.convert_rgba_to_int(stuff.menuData.color.notifications.r, stuff.menuData.color.notifications.g, stuff.menuData.color.notifications.b, stuff.menuData.color.notifications.a))
										end
									else
										v:activate_feat_func()
										if stuff.hotkey_notifications.action then
											menu.notify("Activated "..v.name, "Cheese Menu", 3, cheeseUtils.convert_rgba_to_int(stuff.menuData.color.notifications.r, stuff.menuData.color.notifications.g, stuff.menuData.color.notifications.b, stuff.menuData.color.notifications.a))
										end
									end
								end
							end
						end
						if stuff.hotkey_cooldowns[k] == 0 then
							stuff.hotkey_cooldowns[k] = utils.time_ms() + 500
						else
							stuff.hotkey_cooldowns[k] = utils.time_ms() + 100
						end
					elseif not hotkey:is_down() then
						stuff.hotkey_cooldowns[k] = 0
					end
				end
			end
			system.wait(0)
		end
	end, nil)
	--End of threads

	-- menu configuration features
	menu_configuration_features = {}
	menu_configuration_features.cheesemenuparent = menu.add_feature("Cheese Menu", "parent")

	menu.add_feature("Save Settings", "action", menu_configuration_features.cheesemenuparent.id, function()
		func.save_settings()
		menu.notify("Settings Saved Successfully", "Cheese Menu", 6, 0x00ff00)
	end)

	menu_configuration_features.menuXfeat = menu.add_feature("Menu pos X", "autoaction_value_i", menu_configuration_features.cheesemenuparent.id, function(f)
		if cheeseUtils.get_key(0x65):is_down() or cheeseUtils.get_key(0x0D):is_down() then
			local stat, num = input.get("Put horizontal menu position in pixels", "", 10, 3)
			if stat == 0 and tonumber(num) then
				f.value = num
			end
		end
		func.set_menu_pos(f.value/graphics.get_screen_width())
	end)
	menu_configuration_features.menuXfeat.max = graphics.get_screen_width()
	menu_configuration_features.menuXfeat.mod = 1
	menu_configuration_features.menuXfeat.min = -graphics.get_screen_width()
	menu_configuration_features.menuXfeat.value = math.floor(stuff.menuData.pos_x*graphics.get_screen_width())

	menu_configuration_features.menuYfeat = menu.add_feature("Menu pos Y", "autoaction_value_i", menu_configuration_features.cheesemenuparent.id, function(f)
		if cheeseUtils.get_key(0x65):is_down() or cheeseUtils.get_key(0x0D):is_down() then
			local stat, num = input.get("Put vertical menu position in pixels", "", 10, 3)
			if stat == 0 and tonumber(num) then
				f.value = num
			end
		end
		func.set_menu_pos(nil, f.value/graphics.get_screen_height())
	end)
	menu_configuration_features.menuYfeat.max = graphics.get_screen_height()
	menu_configuration_features.menuYfeat.mod = 1
	menu_configuration_features.menuYfeat.min = -graphics.get_screen_height()
	menu_configuration_features.menuYfeat.value = math.floor(stuff.menuData.pos_y*graphics.get_screen_height())

	menu_configuration_features.menuMouseMove = menu.add_feature("Set position with mouse", "action", menu_configuration_features.cheesemenuparent.id, function()
		local original_x, original_y = stuff.menuData.pos_x, stuff.menuData.pos_y
		local pos = cheeseUtils.mouse.enable()
		local original_toggle = stuff.menuData.menuToggle
		stuff.menuData.menuToggle = true
		stuff.menuData.inputBoxOpen = true
		while true do
			cheeseUtils.mouse.enable()
			func.set_menu_pos((pos.x+1)/2, (pos.y-1)/-2)

			if cheeseUtils.control_is_pressed(0, 142) or cheeseUtils.get_key(0x0D):is_down() then -- left click or enter
				menu_configuration_features.menuXfeat.value = math.floor(stuff.menuData.pos_x*graphics.get_screen_width())
				menu_configuration_features.menuYfeat.value = math.floor(stuff.menuData.pos_y*graphics.get_screen_height())
				break
			elseif cheeseUtils.get_key(0x08):is_down() then
				func.set_menu_pos(original_x, original_y)
				break
			end
			system.wait(0)
		end
		while cheeseUtils.get_key(0x08):is_down() or cheeseUtils.get_key(0x0D):is_down() do
			system.wait(0)
		end
		stuff.menuData.inputBoxOpen = false
		stuff.menuData.menuToggle = original_toggle
	end)

	-- Menu UI

	menu_configuration_features.menu_ui = menu.add_feature("Menu UI", "parent", menu_configuration_features.cheesemenuparent.id)

	menu_configuration_features.headerfeat = menu.add_feature("Header", "autoaction_value_str", menu_configuration_features.menu_ui.id, function(f)
		if f.str_data[f.value + 1] == "NONE" then
			stuff.menuData.header = nil
		else
			stuff.menuData.header = f.str_data[f.value + 1]
		end
	end)
	menu_configuration_features.headerfeat:set_str_data({"NONE", table.unpack(stuff.menuData.files.headers)})

	-- Profiles

		menu_configuration_features.profiles = menu.add_feature("Profiles", "parent", menu_configuration_features.menu_ui.id)

		local callback_ui = function(f, data)
			if f.value == 0 then
				func.load_ui(data)
			else
				func.save_ui(data)
				menu.notify("UI Saved to profile "..data, "Cheese Menu", 6, 0x00ff00)
			end
		end

		local feat_str_data = {"Load", "Save"}

		local original_menu_add = menu.add_feature
		menu.add_feature("Save UI", "action", menu_configuration_features.profiles.id, function()
			local status, name = input.get("name of ui", "", 25, 0)
			if status == 0 then
				func.save_ui(name)
				menu.notify("UI Saved Successfully", "Cheese Menu", 6, 0x00ff00)
				for _, v in pairs(stuff.menuData.files.ui) do
					if v == name then
						return
					end
				end
				stuff.menuData.files.ui[#stuff.menuData.files.ui+1] = name
				local feat = original_menu_add(name, "action_value_str", menu_configuration_features.profiles.id, callback_ui)
				feat:set_str_data(feat_str_data)
				feat.data = name
			end
		end)

		do
			local feat = menu.add_feature("Default", "action_value_str", menu_configuration_features.profiles.id, callback_ui)
			feat:set_str_data(feat_str_data)
			feat.data = "default"
		end

		for _, ui_name in pairs(stuff.menuData.files.ui) do
			if ui_name ~= "default" then
				local feat = menu.add_feature(ui_name, "action_value_str", menu_configuration_features.profiles.id, callback_ui)
				feat:set_str_data(feat_str_data)
				feat.data = ui_name
			end
		end

		--[[ menu_configuration_features.load_ui = menu.add_feature("Load UI", "action_value_str", menu_configuration_features.profiles.id, function(f)
			func.load_ui(f.str_data[f.value + 1])
		end)
		menu_configuration_features.load_ui:set_str_data(stuff.menuData.files.ui) ]]

	menu_configuration_features.layoutParent = menu.add_feature("Layout", "parent", menu_configuration_features.menu_ui.id)

	menu_configuration_features.maxfeats = menu.add_feature("Max features", "autoaction_value_i", menu_configuration_features.layoutParent.id, function(f)
		stuff.menuData:set_max_features(f.value)
	end)
	menu_configuration_features.maxfeats.max = 50
	menu_configuration_features.maxfeats.mod = 1
	menu_configuration_features.maxfeats.min = 1
	menu_configuration_features.maxfeats.value = math.floor(stuff.menuData.max_features)

	menu_configuration_features.menuWidth = menu.add_feature("Menu width", "autoaction_value_i", menu_configuration_features.layoutParent.id, function(f)
		stuff.menuData.width = f.value/graphics.get_screen_width()
	end)
	menu_configuration_features.menuWidth.max = graphics.get_screen_width()
	menu_configuration_features.menuWidth.mod = 1
	menu_configuration_features.menuWidth.min = -graphics.get_screen_width()
	menu_configuration_features.menuWidth.value = math.floor(stuff.menuData.width*graphics.get_screen_width())

	menu_configuration_features.featXfeat = menu.add_feature("Feature dimensions X", "autoaction_value_i", menu_configuration_features.layoutParent.id, function(f)
		stuff.menuData.feature_scale.x = f.value/graphics.get_screen_width()
	end)
	menu_configuration_features.featXfeat.max = graphics.get_screen_width()
	menu_configuration_features.featXfeat.mod = 1
	menu_configuration_features.featXfeat.min = -graphics.get_screen_width()
	menu_configuration_features.featXfeat.value = math.floor(stuff.menuData.feature_scale.x*graphics.get_screen_width())

	menu_configuration_features.featYfeat = menu.add_feature("Feature dimensions Y", "autoaction_value_i", menu_configuration_features.layoutParent.id, function(f)
		stuff.menuData.feature_scale.y = f.value/graphics.get_screen_height()
	end)
	menu_configuration_features.featYfeat.max = graphics.get_screen_height()
	menu_configuration_features.featYfeat.mod = 1
	menu_configuration_features.featYfeat.min = -graphics.get_screen_height()
	menu_configuration_features.featYfeat.value = math.floor(stuff.menuData.feature_scale.y*graphics.get_screen_height())

	menu_configuration_features.feature_offset = menu.add_feature("Feature spacing", "autoaction_value_i", menu_configuration_features.layoutParent.id, function(f)
		stuff.menuData.feature_offset = f.value/graphics.get_screen_height()
		menu_configuration_features.maxfeats:toggle()
	end)
	menu_configuration_features.feature_offset.max = graphics.get_screen_height()
	menu_configuration_features.feature_offset.mod = 1
	menu_configuration_features.feature_offset.min = -graphics.get_screen_height()
	menu_configuration_features.feature_offset.value = math.floor(stuff.menuData.feature_offset*graphics.get_screen_height())

	menu_configuration_features.text_size = menu.add_feature("Text Size", "autoaction_value_f", menu_configuration_features.layoutParent.id, function(f)
		stuff.menuData.text_size_modifier = f.value
	end)
	menu_configuration_features.text_size.max = 5
	menu_configuration_features.text_size.mod = 0.01
	menu_configuration_features.text_size.min = 0.1
	menu_configuration_features.text_size.value = stuff.menuData.text_size_modifier

	menu_configuration_features.footer_size = menu.add_feature("Footer Text Size", "autoaction_value_f", menu_configuration_features.layoutParent.id, function(f)
		stuff.menuData.footer_size_modifier = f.value
	end)
	menu_configuration_features.footer_size.max = 5
	menu_configuration_features.footer_size.mod = 0.01
	menu_configuration_features.footer_size.min = 0.1
	menu_configuration_features.footer_size.value = stuff.menuData.footer_size_modifier

	menu_configuration_features.hint_size = menu.add_feature("Hint Text Size", "autoaction_value_f", menu_configuration_features.layoutParent.id, function(f)
		stuff.menuData.hint_size_modifier = f.value
		func.rewrap_hints(stuff.menuData.fonts.hint)
	end)
	menu_configuration_features.hint_size.max = 5
	menu_configuration_features.hint_size.mod = 0.01
	menu_configuration_features.hint_size.min = 0.1
	menu_configuration_features.hint_size.value = stuff.menuData.hint_size_modifier

	menu_configuration_features.text_y_offset = menu.add_feature("Text Y Offset", "autoaction_value_i", menu_configuration_features.layoutParent.id, function(f)
		stuff.drawFeatParams.textOffset.y = -(f.value/graphics.get_screen_height())
		stuff.menuData.text_y_offset = -(f.value/graphics.get_screen_height())
	end)
	menu_configuration_features.text_y_offset.max = 100
	menu_configuration_features.text_y_offset.mod = 1
	menu_configuration_features.text_y_offset.min = -100
	menu_configuration_features.text_y_offset.value = -math.floor(stuff.menuData.text_y_offset*graphics.get_screen_height())

	menu_configuration_features.border = menu.add_feature("Border", "autoaction_value_i", menu_configuration_features.layoutParent.id, function(f)
		stuff.menuData.border = f.value/graphics.get_screen_height()
	end)
	menu_configuration_features.border.max = graphics.get_screen_height()
	menu_configuration_features.border.mod = 1
	menu_configuration_features.border.min = -graphics.get_screen_height()
	menu_configuration_features.border.value = math.floor(stuff.menuData.border*graphics.get_screen_height())

	menu_configuration_features.selector_speed = menu.add_feature("Selector Speed", "autoaction_value_f", menu_configuration_features.layoutParent.id, function(f)
		stuff.menuData.selector_speed = f.value
	end)
	menu_configuration_features.selector_speed.max = 10
	menu_configuration_features.selector_speed.mod = 0.1
	menu_configuration_features.selector_speed.min = 0.2
	menu_configuration_features.selector_speed.value = stuff.menuData.selector_speed

	-- Online Player Submenu Sorting
		menu_configuration_features.player_submenu_sort = menu.add_feature("Online Players Sort:", "autoaction_value_str", menu_configuration_features.layoutParent.id, function(f)
			table.sort(stuff.PlayerParent, stuff.table_sort_functions[f.value])
			stuff.player_submenu_sort = f.value
		end)
		menu_configuration_features.player_submenu_sort:set_str_data({'PID', 'PID Reversed', 'Alphabetically', 'Alphabetically Reversed', 'Host Priority', 'Host Priority Reversed'})
		menu_configuration_features.player_submenu_sort.value = stuff.player_submenu_sort

	-- Padding
		menu_configuration_features.padding_parent = menu.add_feature("Padding", "parent", menu_configuration_features.layoutParent.id)

			menu_configuration_features.namePadding = menu.add_feature("Name Padding", "autoaction_value_i", menu_configuration_features.padding_parent.id, function(f)
				stuff.menuData.padding.name = f.value/graphics.get_screen_width()
			end)
			menu_configuration_features.namePadding.max = graphics.get_screen_width()
			menu_configuration_features.namePadding.mod = 1
			menu_configuration_features.namePadding.min = -graphics.get_screen_width()
			menu_configuration_features.namePadding.value = math.floor(stuff.menuData.padding.name*graphics.get_screen_width())

			menu_configuration_features.parentPadding = menu.add_feature("Parent Padding", "autoaction_value_i", menu_configuration_features.padding_parent.id, function(f)
				stuff.menuData.padding.parent = f.value/graphics.get_screen_width()
			end)
			menu_configuration_features.parentPadding.max = graphics.get_screen_width()
			menu_configuration_features.parentPadding.mod = 1
			menu_configuration_features.parentPadding.min = -graphics.get_screen_width()
			menu_configuration_features.parentPadding.value = math.floor(stuff.menuData.padding.parent*graphics.get_screen_width())

			menu_configuration_features.valuePadding = menu.add_feature("Value Padding", "autoaction_value_i", menu_configuration_features.padding_parent.id, function(f)
				stuff.menuData.padding.value = f.value/graphics.get_screen_width()
			end)
			menu_configuration_features.valuePadding.max = graphics.get_screen_width()
			menu_configuration_features.valuePadding.mod = 1
			menu_configuration_features.valuePadding.min = -graphics.get_screen_width()
			menu_configuration_features.valuePadding.value = math.floor(stuff.menuData.padding.value*graphics.get_screen_width())

			menu_configuration_features.sliderPadding = menu.add_feature("Slider Padding", "autoaction_value_i", menu_configuration_features.padding_parent.id, function(f)
				stuff.menuData.padding.slider = f.value/graphics.get_screen_width()
			end)
			menu_configuration_features.sliderPadding.max = graphics.get_screen_width()
			menu_configuration_features.sliderPadding.mod = 1
			menu_configuration_features.sliderPadding.min = -graphics.get_screen_width()
			menu_configuration_features.sliderPadding.value = math.floor(stuff.menuData.padding.slider*graphics.get_screen_width())

	-- Slider dimensions
		menu_configuration_features.slider_parent = menu.add_feature("Slider", "parent", menu_configuration_features.layoutParent.id)

			menu_configuration_features.sliderWidth = menu.add_feature("Slider Width", "autoaction_value_i", menu_configuration_features.slider_parent.id, function(f)
				stuff.menuData.slider.width = f.value/graphics.get_screen_width()
			end)
			menu_configuration_features.sliderWidth.max = graphics.get_screen_width()
			menu_configuration_features.sliderWidth.mod = 1
			menu_configuration_features.sliderWidth.min = -graphics.get_screen_width()
			menu_configuration_features.sliderWidth.value = math.floor(stuff.menuData.slider.width*graphics.get_screen_width())

			menu_configuration_features.sliderHeight = menu.add_feature("Slider Height", "autoaction_value_i", menu_configuration_features.slider_parent.id, function(f)
				stuff.menuData.slider.height = f.value/graphics.get_screen_height()
			end)
			menu_configuration_features.sliderHeight.max = graphics.get_screen_height()
			menu_configuration_features.sliderHeight.mod = 1
			menu_configuration_features.sliderHeight.min = -graphics.get_screen_height()
			menu_configuration_features.sliderHeight.value = math.floor(stuff.menuData.slider.height*graphics.get_screen_height())

			menu_configuration_features.sliderheightActive = menu.add_feature("Slider Height Active", "autoaction_value_i", menu_configuration_features.slider_parent.id, function(f)
				stuff.menuData.slider.heightActive = f.value/graphics.get_screen_height()
			end)
			menu_configuration_features.sliderheightActive.max = graphics.get_screen_height()
			menu_configuration_features.sliderheightActive.mod = 1
			menu_configuration_features.sliderheightActive.min = -graphics.get_screen_height()
			menu_configuration_features.sliderheightActive.value = math.floor(stuff.menuData.slider.heightActive*graphics.get_screen_height())

	-- Controls
		menu_configuration_features.controls = menu.add_feature("Controls", "parent", menu_configuration_features.cheesemenuparent.id)

			do
				local control_handler <const> = function(f, k)
					for k, v in pairs(stuff.char_codes) do
						while cheeseUtils.get_key(v):is_down() do
							system.wait(0)
						end
					end
					menu.notify("Press any button\nESC to cancel", "Cheese Menu", 3, cheeseUtils.convert_rgba_to_int(stuff.menuData.color.notifications.r, stuff.menuData.color.notifications.g, stuff.menuData.color.notifications.b, stuff.menuData.color.notifications.a))
					local disablethread = menu.create_thread(stuff.disable_all_controls, nil)
					local stringkey, vk = func.get_hotkey({}, {}, true)
					if stringkey ~= "escaped" then
						stuff.controls[k] = stringkey
						stuff.vkcontrols[k] = vk
						f:set_str_data({stringkey})
					end
					menu.delete_thread(disablethread)
				end
				local proper_names <const> = {
					left = "Left",
					up = "Up",
					right = "Right",
					down = "Down",
					select = "Select",
					back = "Back",
					open = "Open",
					setHotkey = "Set Hotkey",
					specialKey = "Special Key",
					revealMouse = "Reveal Mouse",
				}
				menu_configuration_features.control_features = {}
				for k, v in pairs(stuff.controls) do
					local feat <const> = menu.add_feature(proper_names[k], "action_value_str", menu_configuration_features.controls.id, control_handler)
					feat:set_str_data({v})
					feat.data = k
					menu_configuration_features.control_features[k] = feat
				end
			end

	-- Player Info
	menu_configuration_features.side_window = menu.add_feature("Player Info Window", "parent", menu_configuration_features.menu_ui.id)

		-- On
		menu_configuration_features.side_window_on = menu.add_feature("Draw", "toggle", menu_configuration_features.side_window.id, function(f)
			stuff.menuData.side_window.on = f.on
		end)
		menu_configuration_features.side_window_on.on = stuff.menuData.side_window.on

		-- Offset
		menu_configuration_features.side_window_offsetx = menu.add_feature("X Offset", "autoaction_value_i", menu_configuration_features.side_window.id, function(f)
			if cheeseUtils.get_key(0x65):is_down() or cheeseUtils.get_key(0x0D):is_down() then
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
			if cheeseUtils.get_key(0x65):is_down() or cheeseUtils.get_key(0x0D):is_down() then
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
			if cheeseUtils.get_key(0x65):is_down() or cheeseUtils.get_key(0x0D):is_down() then
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
			if cheeseUtils.get_key(0x65):is_down() or cheeseUtils.get_key(0x0D):is_down() then
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
			if cheeseUtils.get_key(0x65):is_down() or cheeseUtils.get_key(0x0D):is_down() then
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


	-- Background
		menu_configuration_features.backgroundparent = menu.add_feature("Background", "parent", menu_configuration_features.menu_ui.id)

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
				if cheeseUtils.get_key(0x65):is_down() or cheeseUtils.get_key(0x0D):is_down() then
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
				if cheeseUtils.get_key(0x65):is_down() or cheeseUtils.get_key(0x0D):is_down() then
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

	-- Footer
		menu_configuration_features.footer = menu.add_feature("Footer", "parent", menu_configuration_features.menu_ui.id)

			menu_configuration_features.footer_size = menu.add_feature("Footer Size", "autoaction_value_i", menu_configuration_features.footer.id, function(f)
				if cheeseUtils.get_key(0x65):is_down() or cheeseUtils.get_key(0x0D):is_down() then
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

			menu_configuration_features.footer_y_offset = menu.add_feature("Footer Y Offset", "autoaction_value_i", menu_configuration_features.footer.id, function(f)
				stuff.menuData.footer.footer_y_offset = (f.value/graphics.get_screen_height())
			end)
			menu_configuration_features.footer_y_offset.max = 100
			menu_configuration_features.footer_y_offset.mod = 1
			menu_configuration_features.footer_y_offset.min = -100
			menu_configuration_features.footer_y_offset.value = math.floor(stuff.menuData.footer.footer_y_offset*graphics.get_screen_height())

			menu_configuration_features.footerPadding = menu.add_feature("Padding", "autoaction_value_i", menu_configuration_features.footer.id, function(f)
				if cheeseUtils.get_key(0x65):is_down() or cheeseUtils.get_key(0x0D):is_down() then
					local stat, num = input.get("num", "", 10, 3)
					if stat == 0 and tonumber(num) then
						stuff.menuData.footer.padding = num/graphics.get_screen_width()
						f.value = num
					end
				end
				stuff.menuData.footer.padding = f.value/graphics.get_screen_width()
			end)
			menu_configuration_features.footerPadding.max = graphics.get_screen_width()
			menu_configuration_features.footerPadding.mod = 1
			menu_configuration_features.footerPadding.min = -graphics.get_screen_width()
			menu_configuration_features.footerPadding.value = math.floor(stuff.menuData.footer.padding*graphics.get_screen_width())

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

	-- Fonts
		local fontStrData = {
			"Menu Head",
			"Menu Tab",
			"Menu Entry",
			"Menu Foot",
			"Script 1",
			"Script 2",
			"Script 3",
			"Script 4",
			"Script 5",
		}
		menu_configuration_features.fonts = menu.add_feature("Fonts", "parent", menu_configuration_features.menu_ui.id)

			menu_configuration_features.text_font = menu.add_feature("Text Font", "autoaction_value_str", menu_configuration_features.fonts.id, function(f)
				stuff.menuData.fonts.text = f.value
			end)
			menu_configuration_features.text_font:set_str_data(fontStrData)
			menu_configuration_features.text_font.value = stuff.menuData.fonts.text

			menu_configuration_features.footer_font = menu.add_feature("Footer Font", "autoaction_value_str", menu_configuration_features.fonts.id, function(f)
				stuff.menuData.fonts.footer = f.value
			end)
			menu_configuration_features.footer_font:set_str_data(fontStrData)
			menu_configuration_features.footer_font.value = stuff.menuData.fonts.footer

			menu_configuration_features.hint_font = menu.add_feature("Hint Font", "autoaction_value_str", menu_configuration_features.fonts.id, function(f)
				stuff.menuData.fonts.hint = f.value
				func.rewrap_hints(f.value)
			end)
			menu_configuration_features.hint_font:set_str_data(fontStrData)
			menu_configuration_features.hint_font.value = stuff.menuData.fonts.hint

	-- Hotkeys
		menu_configuration_features.hotkeyparent = menu.add_feature("Hotkey notifications", "parent", menu_configuration_features.cheesemenuparent.id)

			menu.add_feature("Toggle notification", "toggle", menu_configuration_features.hotkeyparent.id, function(f)
				stuff.hotkey_notifications.toggle = f.on
			end).on = stuff.hotkey_notifications.toggle
			menu.add_feature("Action notification", "toggle", menu_configuration_features.hotkeyparent.id, function(f)
				stuff.hotkey_notifications.action = f.on
			end).on = stuff.hotkey_notifications.action

	-- Colors
		local colorParent = menu.add_feature("Colors", "parent", menu_configuration_features.menu_ui.id)
			do
				local function input_num(f)
					if cheeseUtils.get_key(0x65):is_down() or cheeseUtils.get_key(0x0D):is_down() then
						local stat, num = input.get("num", "", 10, 3)
						if stat == 0 and tonumber(num) then
							f.value = num
						end
					end
				end

				local function pick_color(f, data)
					while cheeseUtils.get_key(0x0D):is_down() or cheeseUtils.get_key(0x08):is_down() or cheeseUtils.get_key(0x1B):is_down() do
						system.wait(0)
					end
					local original_colors = {
						r = data.feats.r.value,
						g = data.feats.g.value,
						b = data.feats.b.value,
						a = data.feats.a.value,
					}

					local menu_color = stuff.menuData.color[data.color_key]
					local is_table = type(menu_color) == "table"

					local status, ABGR, r, g, b, a
					repeat
						status, ABGR, r, g, b, a = cheeseUtils.pick_color(original_colors.r, original_colors.g, original_colors.b, original_colors.a)

						if status == 2 then
							menu.notify("Cancelled", "Cheese Menu", 2, cheeseUtils.convert_rgba_to_int(stuff.menuData.color.notifications.r, stuff.menuData.color.notifications.g, stuff.menuData.color.notifications.b, stuff.menuData.color.notifications.a))

							for color, val in pairs(original_colors) do
								data.feats[color].value = val
								if is_table then
									menu_color[color] = val
								end
							end

							if not is_table then
								stuff.menuData.color[data.color_key] = cheeseUtils.convert_rgba_to_int(original_colors.r, original_colors.g, original_colors.b, original_colors.a)
							end

							break
						end

						data.feats.r.value = r
						data.feats.g.value = g
						data.feats.b.value = b
						data.feats.a.value = a

						if is_table then
							menu_color.r = r
							menu_color.g = g
							menu_color.b = b
							menu_color.a = a
						else
							stuff.menuData.color[data.color_key] = ABGR
						end

						system.wait(0)
					until status == 0
				end

				local tempColor = {}
				for k, v in pairs(stuff.menuData.color) do
					tempColor[#tempColor+1] = {k, v, sortname = k:gsub("feature_([^s])", "feature_a%1")}
				end
				table.sort(tempColor, function(a, b) return a["sortname"] < b["sortname"] end)

				for _, v in pairs(tempColor) do
					local is_table = type(v[2]) == "table"

					menu_configuration_features[v[1]] = {}
					local vParent = menu.add_feature(v[1], "parent", colorParent.id)

					menu.add_feature("Pick Color", "action", vParent.id, pick_color).data = {
						feats = menu_configuration_features[v[1]],
						color_key = v[1]
					}

					menu_configuration_features[v[1]].r = menu.add_feature("Red", "autoaction_value_i", vParent.id, function(f)
						input_num(f)
						stuff.menuData.color:set_color(v[1], f.value)
					end)
					menu_configuration_features[v[1]].r.max = 255
					menu_configuration_features[v[1]].r.value = is_table and v[2].r or cheeseUtils.convert_int_to_rgba(v[2], "r")

					menu_configuration_features[v[1]].g = menu.add_feature("Green", "autoaction_value_i", vParent.id, function(f)
						input_num(f)
						stuff.menuData.color:set_color(v[1], nil, f.value)
					end)
					menu_configuration_features[v[1]].g.max = 255
					menu_configuration_features[v[1]].g.value = is_table and v[2].g or cheeseUtils.convert_int_to_rgba(v[2], "g")

					menu_configuration_features[v[1]].b = menu.add_feature("Blue", "autoaction_value_i", vParent.id, function(f)
						input_num(f)
						stuff.menuData.color:set_color(v[1], nil, nil, f.value)
					end)
					menu_configuration_features[v[1]].b.max = 255
					menu_configuration_features[v[1]].b.value = is_table and v[2].b or cheeseUtils.convert_int_to_rgba(v[2], "b")

					menu_configuration_features[v[1]].a = menu.add_feature("Alpha", "autoaction_value_i", vParent.id, function(f)
						input_num(f)
						stuff.menuData.color:set_color(v[1], nil, nil, nil, f.value)
					end)
					menu_configuration_features[v[1]].a.max = 255
					menu_configuration_features[v[1]].a.value = is_table and v[2].a or cheeseUtils.convert_int_to_rgba(v[2], "a")
				end
			end

	-- loading default ui & settings
	func.load_ui("default")
	func.load_settings()

	--changing menu functions to ui functions
	local menu_get_feature_by_hierarchy_key <const> = menu.get_feature_by_hierarchy_key
	menu_originals = setmetatable({
		--get_feature_by_hierarchy_key = menu.get_feature_by_hierarchy_key,
		add_feature = menu.add_feature,
		add_player_feature = menu.add_player_feature,
		delete_feature = menu.delete_feature,
		delete_player_feature = menu.delete_player_feature,
		get_player_feature = menu.get_player_feature,
	}, {__newindex = function() end})
	menu.add_feature = func.add_feature
	menu.add_player_feature = func.add_player_feature
	menu.delete_feature = func.delete_feature
	menu.delete_player_feature = func.delete_player_feature
	menu.get_player_feature = func.get_player_feature
	menu.get_feature_by_hierarchy_key = function(hierarchy_key)
		if string.find(hierarchy_key:lower(), "trusted") or string.find(hierarchy_key:lower(), "Proddy's Script Manager") then
			return
		end
		local feat, duplicate
		feat = menu_get_feature_by_hierarchy_key(hierarchy_key)
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
	--
	func.set_player_feat_parent("Online Players", 0)

	-- Proddy's Script Manager
		gltw.read("Trusted Flags", stuff.path.cheesemenu, stuff, true, true)
		menu.is_trusted_mode_enabled = function(flag)
			if not flag then
				return stuff.trusted_mode & 7 == 7, stuff.trusted_mode_notification
			else
				return stuff.trusted_mode & flag == flag, stuff.trusted_mode_notification
			end
		end

		dofile("\\scripts\\cheesemenu\\libs\\Proddy's Script Manager.lua")

		do
			local trusted_parent = menu_get_feature_by_hierarchy_key("local.script_features.cheese_menu.proddy_s_script_manager.trusted_mode")

			menu_originals.add_feature("Save Trusted Flags", "action", trusted_parent.id, function()
				gltw.write({trusted_mode = stuff.trusted_mode, trusted_mode_notification = stuff.trusted_mode_notification}, "Trusted Flags", stuff.path.cheesemenu, nil, nil, true)
				menu.notify("Saved Successfully", "Cheese Menu", 2, 0x00ff00)
			end)

			menu_originals.add_feature("Trusted Flags Notification", "toggle", trusted_parent.id, function(f)
				stuff.trusted_mode_notification = f.on
			end).on = stuff.trusted_mode_notification

			local trusted_names = {
				[0] = "Stats",
				[1] = "Globals / Locals",
				[2] = "Natives",
				[3] = "HTTP",
				[4] = "Memory"
			}

			for i = 0, 4 do
				menu_originals.add_feature(trusted_names[i], "toggle", trusted_parent.id, function(f)
					if f.on then
						stuff.trusted_mode = stuff.trusted_mode | 1 << i
					else
						stuff.trusted_mode = stuff.trusted_mode ~ 1 << i
					end
				end).on = stuff.trusted_mode & 1 << i ~= 0
			end
		end
	--
	menu.notify("Kektram for teaching me lua & sharing neat functions\n\nRimuru for making the first separate ui that helped me in making cheese menu\n\nProddy for showing better ways to do things & sharing Script Manager", "Credits:", 12, 0x00ff00)
	menu.notify("Controls can be found in\nScript Features > Cheese Menu > Controls", "CheeseMenu by GhostOne\n"..stuff.controls.open.." to open", 6, 0x00ff00)	
end
if httpTrustedOff then
	loadCurrentMenu()
end
