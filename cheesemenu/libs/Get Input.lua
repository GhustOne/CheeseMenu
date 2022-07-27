--Made by GhostOne

local gginput = {indicator_timer = utils.time_ms() + 750, indicator = false}
gginput.char_codes = {
    {
		[0x30] = {"0", ")"},
		[0x31] = {"1", "!"},
		[0x32] = {"2", "@"},
		[0x33] = {"3", "#"},
		[0x34] = {"4", "$"},
		[0x35] = {"5", "%"},
		[0x36] = {"6", "^"},
		[0x37] = {"7", "&"},
		[0x38] = {"8", "*"},
		[0x39] = {"9", "("},
		[0x41] = {"a"},
		[0x42] = {"b"},
		[0x43] = {"c"},
		[0x44] = {"d"},
		[0x45] = {"e"},
		[0x46] = {"f"},
		[0x47] = {"g"},
		[0x48] = {"h"},
		[0x49] = {"i"},
		[0x4A] = {"j"},
		[0x4B] = {"k"},
		[0x4C] = {"l"},
		[0x4D] = {"m"},
		[0x4E] = {"n"},
		[0x4F] = {"o"},
		[0x50] = {"p"},
		[0x51] = {"q"},
		[0x52] = {"r"},
		[0x53] = {"s"},
		[0x54] = {"t"},
		[0x55] = {"u"},
		[0x56] = {"v"},
		[0x57] = {"w"},
		[0x58] = {"x"},
		[0x59] = {"y"},
		[0x5A] = {"z"},
		[0x60] = {"0", ")"},
		[0x61] = {"1", "!"},
		[0x62] = {"2", "@"},
		[0x63] = {"3", "#"},
		[0x64] = {"4", "$"},
		[0x65] = {"5", "%"},
		[0x66] = {"6", "^"},
		[0x67] = {"7", "&"},
		[0x68] = {"8", "*"},
		[0x69] = {"9", "("},
		[0x20] = {" "},
		[0xBA] = {";", ":"},
		[0xBB] = {"=", "+"},
		[0xBC] = {",", "<"},
		[0xBD] = {"-", "_"},
		[0xBE] = {".", ">"},
		[0xBF] = {"/", "?"},
		[0xC0] = {"`", "~"},
		[0xDB] = {"[", "{"},
		[0xDC] = {"\\", "|"},
		[0xDD] = {"]", "}"},
		[0xDE] = {"\'", "\""},
		[0x6A] = {"*"},
		[0x6B] = {"+"},
		[0x6D] = {"-"},
		[0x6E] = {"."},
		[0x6F] = {"/"}
	},
	{
		[0x41] = {"a"},
		[0x42] = {"b"},
		[0x43] = {"c"},
		[0x44] = {"d"},
		[0x45] = {"e"},
		[0x46] = {"f"},
		[0x47] = {"g"},
		[0x48] = {"h"},
		[0x49] = {"i"},
		[0x4A] = {"j"},
		[0x4B] = {"k"},
		[0x4C] = {"l"},
		[0x4D] = {"m"},
		[0x4E] = {"n"},
		[0x4F] = {"o"},
		[0x50] = {"p"},
		[0x51] = {"q"},
		[0x52] = {"r"},
		[0x53] = {"s"},
		[0x54] = {"t"},
		[0x55] = {"u"},
		[0x56] = {"v"},
		[0x57] = {"w"},
		[0x58] = {"x"},
		[0x59] = {"y"},
		[0x5A] = {"z"},
	},
	{
		[0x41] = {"a"},
		[0x42] = {"b"},
		[0x43] = {"c"},
		[0x44] = {"d"},
		[0x45] = {"e"},
		[0x46] = {"f"},
		[0x47] = {"g"},
		[0x48] = {"h"},
		[0x49] = {"i"},
		[0x4A] = {"j"},
		[0x4B] = {"k"},
		[0x4C] = {"l"},
		[0x4D] = {"m"},
		[0x4E] = {"n"},
		[0x4F] = {"o"},
		[0x50] = {"p"},
		[0x51] = {"q"},
		[0x52] = {"r"},
		[0x53] = {"s"},
		[0x54] = {"t"},
		[0x55] = {"u"},
		[0x56] = {"v"},
		[0x57] = {"w"},
		[0x58] = {"x"},
		[0x59] = {"y"},
		[0x5A] = {"z"},
		[0x60] = {"0"},
		[0x61] = {"1"},
		[0x62] = {"2"},
		[0x63] = {"3"},
		[0x64] = {"4"},
		[0x65] = {"5"},
		[0x66] = {"6"},
		[0x67] = {"7"},
		[0x68] = {"8"},
		[0x69] = {"9"},
		[0x30] = {"0"},
		[0x31] = {"1"},
		[0x32] = {"2"},
		[0x33] = {"3"},
		[0x34] = {"4"},
		[0x35] = {"5"},
		[0x36] = {"6"},
		[0x37] = {"7"},
		[0x38] = {"8"},
		[0x39] = {"9"}
	},
	{
		[0xBD] = {"-"},
		[0x6D] = {"-"},
		[0x60] = {"0"},
		[0x61] = {"1"},
		[0x62] = {"2"},
		[0x63] = {"3"},
		[0x64] = {"4"},
		[0x65] = {"5"},
		[0x66] = {"6"},
		[0x67] = {"7"},
		[0x68] = {"8"},
		[0x69] = {"9"},
		[0x30] = {"0"},
		[0x31] = {"1"},
		[0x32] = {"2"},
		[0x33] = {"3"},
		[0x34] = {"4"},
		[0x35] = {"5"},
		[0x36] = {"6"},
		[0x37] = {"7"},
		[0x38] = {"8"},
		[0x39] = {"9"}
	},
	{
		[0xBD] = {"-"},
		[0x6D] = {"-"},
		[0x60] = {"0"},
		[0x61] = {"1"},
		[0x62] = {"2"},
		[0x63] = {"3"},
		[0x64] = {"4"},
		[0x65] = {"5"},
		[0x66] = {"6"},
		[0x67] = {"7"},
		[0x68] = {"8"},
		[0x69] = {"9"},
		[0x30] = {"0"},
		[0x31] = {"1"},
		[0x32] = {"2"},
		[0x33] = {"3"},
		[0x34] = {"4"},
		[0x35] = {"5"},
		[0x36] = {"6"},
		[0x37] = {"7"},
		[0x38] = {"8"},
		[0x39] = {"9"},
		[0x6E] = {"."},
		[0xBE] = {"."},
	},
	{
		[0xBD] = {"-"},
		[0x6D] = {"-"},
		[0x60] = {"0"},
		[0x61] = {"1"},
		[0x62] = {"2"},
		[0x63] = {"3"},
		[0x64] = {"4"},
		[0x65] = {"5"},
		[0x66] = {"6"},
		[0x67] = {"7"},
		[0x68] = {"8"},
		[0x69] = {"9"},
		[0x30] = {"0"},
		[0x31] = {"1"},
		[0x32] = {"2"},
		[0x33] = {"3"},
		[0x34] = {"4"},
		[0x35] = {"5"},
		[0x36] = {"6"},
		[0x37] = {"7"},
		[0x38] = {"8"},
		[0x39] = {"9"},
		[0x6E] = {"."},
		[0xBE] = {"."},
	},
}

--Functions

	-- Credits to Proddy for this function
	gginput.Keys = {}
	function gginput.get_key(...)
		local args = {...}
		assert(#args > 0, "must give at least one key")
		local ID = table.concat(args, "|")
		if not gginput.Keys[ID] then
			local key = MenuKey()
			for i=1,#args do
			key:push_vk(args[i])
			end
			gginput.Keys[ID] = key
		end

		return gginput.Keys[ID]
	end

	function gginput.do_key(key, pressed, funcPressed, ...)
		if gginput.get_key(key):is_down() and ((utils.time_ms() > pressed[key]) or (pressed[key] == 0)) then
			funcPressed(...)
			if pressed[key] == 0 then
				pressed[key] = utils.time_ms() + 500
			else
				pressed[key] = utils.time_ms() + 30
			end
		elseif not gginput.get_key(key):is_down() then
			pressed[key] = 0
		end
	end

    function gginput.draw_outline(v2pos, v2size, color, thickness)
        thickness = v2(thickness / graphics.get_screen_width() * 2, thickness / graphics.get_screen_height() * 2)
        scriptdraw.draw_rect(v2(v2pos.x, v2pos.y - (v2size.y/2)), v2(v2size.x + thickness.x, thickness.y), color)
        scriptdraw.draw_rect(v2(v2pos.x, v2pos.y + (v2size.y/2)), v2(v2size.x + thickness.x, thickness.y), color)
        scriptdraw.draw_rect(v2(v2pos.x - (v2size.x/2), v2pos.y), v2(thickness.x, v2size.y - thickness.y), color)
        scriptdraw.draw_rect(v2(v2pos.x + (v2size.x/2), v2pos.y), v2(thickness.x, v2size.y - thickness.y), color)
    end

    function gginput.draw_input(inputTable, bg_color, inputbox_color, outline_color, text_color)
		local string = table.concat(inputTable.string)
		if gginput.indicator then
			string = string:sub(1, inputTable.cursor-1).."_"..string:sub(inputTable.cursor+1, #string)
		end
        scriptdraw.draw_rect(v2(0, 0), v2(2, 2), bg_color) -- background
        gginput.draw_outline(v2(0, 0), v2(0.9390625, 0.06180555555555), outline_color, 2)
        scriptdraw.draw_rect(v2(0, 0), v2(0.9375, 0.0590277777777778), inputbox_color) -- inputBox
		scriptdraw.draw_text(string, v2(-0.4609375, 0.01111111111111111), v2(2, 2), 0.8, text_color, 0)
		scriptdraw.draw_text(inputTable.title, v2(-scriptdraw.get_text_size(inputTable.title, 1.2).x/graphics.get_screen_width(), 0.10555554), v2(2, 2), 1.2, 0xDC000000 | (text_color & 0xFFFFFF), 0)

		local text_width = scriptdraw.get_text_size(table.concat(inputTable.string, "", 1, inputTable.cursor):gsub(" ", "."), 0.8).x/graphics.get_screen_width()*2
		scriptdraw.draw_text("_", v2(-0.4609375 + text_width + 0.0015625, 0.01111111111111111), v2(2, 2), 0.8, 0x64000000 | (text_color & 0xFFFFFF), 0)
    end

	function gginput.draw_thread(inputTable)
		while true do
			for i = 0, 357 do
				controls.disable_control_action(0, i, true)
			end
			if utils.time_ms() > gginput.indicator_timer then
				gginput.indicator = not gginput.indicator
				gginput.indicator_timer = utils.time_ms() + 750
			end
			gginput.draw_input(inputTable, 0x64000000, 0xC8000000, 0xC8FFFFFF, 0xC8FFFFFF)
			system.wait(0)
		end
	end

	function gginput.disableESC()
		while gginput.get_key(0x1B):is_down() do
			controls.disable_control_action(0, 200, true)
			system.wait(0)
		end
		controls.disable_control_action(0, 200, true)
	end

	function gginput.moveCursorRight(inputTable, moveAmount)
		if gginput.get_key(0x11):is_down() then
			for i = inputTable.cursor+1, #inputTable.string do
				if inputTable.string[i] == " " then
					if i == inputTable.cursor+1 then
						for i = inputTable.cursor+1, #inputTable.string do
							if inputTable.string[i] ~= " " then
								inputTable.cursor = i-1
								break
							end
						end
					else
						inputTable.cursor = i-1
					end
					break
				elseif i == #inputTable.string then
					inputTable.cursor = #inputTable.string
				end
			end
		elseif not (inputTable.cursor >= #inputTable.string) then
			inputTable.cursor = inputTable.cursor + moveAmount
		end
	end
	function gginput.moveCursorLeft(inputTable, moveAmount)
		if gginput.get_key(0x11):is_down() then
			for i = inputTable.cursor, 2, -1 do
				if inputTable.string[i] == " " then
					if i == inputTable.cursor then
						for i = inputTable.cursor, 2, -1 do
							if inputTable.string[i] ~= " " then
								inputTable.cursor = i
								break
							end
						end
					else
						inputTable.cursor = i
					end
					break
				elseif i == 2 then
					inputTable.cursor = 1
				end
			end
		elseif not (inputTable.cursor <= 1) then
			inputTable.cursor = inputTable.cursor - moveAmount
		end
	end

	function gginput.write_char(keyTable, inputTable)
		if gginput.get_key(0x10):is_down() then
			if inputTable.cursor == #inputTable.string then
				inputTable.string[#inputTable.string+1] = keyTable[2] or keyTable[1]:upper()
			else
				table.insert(inputTable.string, inputTable.cursor+1, keyTable[2] or keyTable[1]:upper())
			end
		else
			if inputTable.cursor == #inputTable.string then
				inputTable.string[#inputTable.string+1] = keyTable[1]
			else
				table.insert(inputTable.string, inputTable.cursor+1, keyTable[1])
			end
		end

		gginput.moveCursorRight(inputTable, 1)
	end

	function gginput.paste(stringInput, inputTable)
		if inputTable.cursor == #inputTable.string then
			for char in stringInput:gmatch(".") do
				if #inputTable.string-1 ~= inputTable.limit then
					inputTable.string[#inputTable.string+1] = char
				end
			end
			inputTable.cursor = #inputTable.string
		else
			for char in stringInput:gmatch(".") do
				if #inputTable.string-1 ~= inputTable.limit then
					table.insert(inputTable.string, inputTable.cursor+1, char)
					inputTable.cursor = inputTable.cursor+1
				end
			end
		end
	end

	function gginput.delete_char(inputTable, range_start, range_end)
		if not range_start then
			gginput.moveCursorLeft(inputTable, 1)
			if inputTable.cursor == #inputTable.string-1 then
				inputTable.string[#inputTable.string] = nil
			else
				table.remove(inputTable.string, inputTable.cursor+1)
			end
		else
			if range_end ~= #inputTable.string then
				inputTable.cursor = range_start
				for i = range_end, range_start+1, -1 do
					table.remove(inputTable.string, i)
				end
			else
				inputTable.cursor = range_start
				for i = range_start+1, #inputTable.string do
					inputTable.string[i] = i == 1 and "" or nil
				end
			end
		end
	end

	function gginput.delete(inputTable)
		if gginput.get_key(0x11):is_down() then
			local range_start
			for i = inputTable.cursor, 1, -1 do
				if inputTable.string[i] == " " then
					if i == inputTable.cursor then
						for i = inputTable.cursor, 1, -1 do
							if inputTable.string[i] ~= " " then
								range_start = i
								break
							end
						end
					else
						range_start = i
					end
					break
				elseif i == 1 then
					range_start = 1
				end
			end
			gginput.delete_char(inputTable, range_start, inputTable.cursor)
		else
			gginput.delete_char(inputTable)
		end
	end

	local shift_esc = MenuKey()
	shift_esc:push_vk(0x11)
	shift_esc:push_vk(0x1B)
	function gginput.reset_menu_nav()
		if shift_esc:is_down() then
			menu.set_menu_can_navigate(true)
			menu.notify("Reset menu navigation")
		end
	end


	function gginput.get_input(title, default, len, inputtype, inputTable)
		local menuNavThread = menu.create_thread(gginput.reset_menu_nav)
		menu.set_menu_can_navigate(false)
		local pressed = {}

		for k, v in pairs(gginput.char_codes[1]) do
			if gginput.get_key(k):is_down() then
				pressed[k] = utils.time_ms() + 2000
			else
				pressed[k] = 0
			end
		end

		inputtype = (inputtype <= 5 and inputtype >= 0) and inputtype or 0
		inputtype = inputtype + 1
		local charTable = gginput.char_codes[inputtype]
		local pasteCheck = {}
		for k, v in pairs(charTable) do
			local concatenated = table.concat(v)
			pasteCheck[#pasteCheck+1] = concatenated
			if concatenated ~= concatenated:upper() then
				pasteCheck[#pasteCheck+1] = concatenated:upper()
			end
		end
		pasteCheck = "[^"..table.concat(pasteCheck).."]"

		inputTable = inputTable or {}
		inputTable.string = {""}
		inputTable.state = 1
		inputTable.cursor = 1
		inputTable.title = title
		inputTable.limit = len or 25

		gginput.paste(default, inputTable)

		local drawThread = menu.create_thread(gginput.draw_thread, inputTable)
		while gginput.get_key(0x0D):is_down() do
			system.wait()
		end
		while not (gginput.get_key(0x0D):is_down() or gginput.get_key(0x1B):is_down()) do
			for k, v in pairs(charTable) do
				if not gginput.get_key(0x11):is_down() and #inputTable.string-1 ~= len then
					gginput.do_key(k, pressed, gginput.write_char, v, inputTable)
				end
			end

			if gginput.get_key(0x11, 0x56):is_down() then
				gginput.paste(utils.from_clipboard():gsub("\r\n", " "):gsub(pasteCheck, ""), inputTable)
				while gginput.get_key(0x11, 0x56):is_down() do
					system.wait()
				end
			elseif gginput.get_key(0x11, 0x43):is_down() then
				utils.to_clipboard(table.concat(inputTable.string))
			end

			gginput.do_key(0x08, pressed, gginput.delete, inputTable) -- backspace
			gginput.do_key(0x27, pressed, gginput.moveCursorRight, inputTable, 1) -- right
			gginput.do_key(0x25, pressed, gginput.moveCursorLeft, inputTable, 1) -- left
			system.wait(0)
		end
		local success = gginput.get_key(0x0D):is_down()
		while gginput.get_key(0x0D):is_down() do
			system.wait(0)
		end
		menu.delete_thread(drawThread)
		menu.delete_thread(menuNavThread)
		menu.set_menu_can_navigate(true)
		menu.create_thread(gginput.disableESC)
		inputTable.string = table.concat(inputTable.string)
		inputTable.state = success and 0 or 2

		return inputTable.state, success and inputTable.string or nil
	end
--

return gginput
