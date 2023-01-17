--Made by GhostOne
local cheeseUtils = {}

-- Credit to kektram for this whole function ~ a little modified to focus on fractionals
cheeseUtils.memoize = {}
do
	local sign_bit_x <const> = 1 << 62
	local sign_bit_y <const> = 1 << 61
	local max_30_bit_num <const> = 1073740823
	local v2 <const> = v2
	local memoized <const> = {}
	function cheeseUtils.memoize.v2(x, y)
		x = x or 0
		y = y or 0
		local xi = x * 100000000 // 1 -- modified from 1000 to 100,000,000 to support up to 10^-7 fractional digits ~ this limits it to either single or double digits with fractions
		local yi = y * 100000000 // 1 -- same here
		if xi >= -max_30_bit_num
		and xi <= max_30_bit_num
		and yi >= -max_30_bit_num
		and yi <= max_30_bit_num then
			local signs = 0
			if xi < 0 then
				xi = xi * -1
				signs = signs | sign_bit_x
			end
			if yi < 0 then
				yi = yi * -1
				signs = signs | sign_bit_y
			end
			local hash <const> = signs | xi << 30 | yi
			memoized[hash] = memoized[hash] or v2(x, y)
			return memoized[hash]
		else
			return v2(x, y)
		end
	end
end
--

function cheeseUtils.draw_outline(v2pos, v2size, color, thickness)
    local thickness_y = thickness / graphics.get_screen_height() * 2
    local thickness_x = thickness / graphics.get_screen_width() * 2

    scriptdraw.draw_rect(
        cheeseUtils.memoize.v2(v2pos.x, v2pos.y - (v2size.y/2)),
        cheeseUtils.memoize.v2(v2size.x + thickness_x, thickness_y),
        color
    )

    scriptdraw.draw_rect(
        cheeseUtils.memoize.v2(v2pos.x, v2pos.y + (v2size.y/2)),
        cheeseUtils.memoize.v2(v2size.x + thickness_x, thickness_y),
        color
    )

    scriptdraw.draw_rect(
        cheeseUtils.memoize.v2(v2pos.x - (v2size.x/2), v2pos.y),
        cheeseUtils.memoize.v2(thickness_x, v2size.y - thickness_y),
        color
    )

    scriptdraw.draw_rect(
        cheeseUtils.memoize.v2(v2pos.x + (v2size.x/2), v2pos.y),
        cheeseUtils.memoize.v2(thickness_x, v2size.y - thickness_y),
        color
    )
end

-- Credit to Proddy for this function
cheeseUtils.Keys = {}
function cheeseUtils.get_key(...)
	local args = {...}
	assert(#args > 0, "must give at least one key")
	local ID = table.concat(args, "|")
	if not cheeseUtils.Keys[ID] then
		local key = MenuKey()
		for i=1,#args do
		   key:push_vk(args[i])
		end
		cheeseUtils.Keys[ID] = key
	end

	return cheeseUtils.Keys[ID]
end

function cheeseUtils.new_reusable_v2(limit)
	limit = limit or 2

	local counter = 1
	local v2Table = {}
	for i = 1, limit do
		v2Table[i] = v2()
	end

	---@param x number
	---@param y number
	---@return v2
	return function(x, y)
		x = x or 0
		y = y or 0
		local vector2d = v2Table[counter]
		counter = counter + 1
		counter = counter <= limit and counter or 1

		vector2d.x, vector2d.y = x, y

		return vector2d
	end
end

-- Selector
do
	local textv2 = v2(2, 2)
	local reuse_v2 = cheeseUtils.new_reusable_v2()

	local key = {
		enter = MenuKey(),
		backspace = MenuKey(),
		up = MenuKey(),
		down = MenuKey(),
	}
	key.enter:push_vk(0x0D)
	key.backspace:push_vk(0x08)
	key.up:push_vk(0x26)
	key.down:push_vk(0x28)

	local key_waits = {}
	local function get_key_wait(str_key)
		local vk_key = key[str_key]
		if vk_key:is_down() and ((utils.time_ms() > key_waits[str_key]) or (key_waits[str_key] == 0)) then
			if key_waits[str_key] == 0 then
				key_waits[str_key] = utils.time_ms() + 500
			else
				key_waits[str_key] = utils.time_ms() + 100
			end
			return true
		elseif not vk_key:is_down() then
			key_waits[str_key] = 0
		end
		return false
	end

	--local speed_modifier = 0.5
	local function draw_selector(stuff)
		while true do
			local selected = stuff.selected
			scriptdraw.draw_rect(reuse_v2(0, 0), textv2, 0x7D000000)
			scriptdraw.draw_text(stuff.selected_str, reuse_v2(-0.02, 0), textv2, 1 / stuff.text_size_rel_to_res, 0xFFFFFFFF, 1 << 4)

			if stuff.move then
				local is_going_up = stuff.move == "up"
				if (is_going_up and stuff.selected - 1 >= 1) or (not is_going_up and stuff.selected + 1 <= #stuff.items) then
					stuff.offset = is_going_up and stuff.offset - stuff.offset_step or stuff.offset + stuff.offset_step
					stuff.size_offset = stuff.size_offset + stuff.size_step
					if stuff.offset >= 0.08 or stuff.offset <= -0.08 then
						stuff.offset = 0
						stuff.size_offset = 0
						stuff.next_selected = 0

						stuff.selected = is_going_up and stuff.selected - 1 or stuff.selected + 1
						selected = stuff.selected
						stuff.move = nil
					end
				else
					stuff.move = nil
				end
			else
				stuff.offset = 0
				stuff.size_offset = 0
				stuff.next_selected = 0
			end

			local min = selected - 5 >= 1 and selected - 5 or 1
			local max = selected + 5 <= #stuff.items and selected + 5 or #stuff.items
			for i = min, max do
				if stuff.items[i] then
					local size = i == selected and 1.3 or 1
					size = i == stuff.next_selected and size + stuff.size_offset or i == selected and size - stuff.size_offset or size
					local alpha = stuff.move == "up" and math.max(math.floor(255 - math.abs((i - selected) + math.abs(stuff.offset)/0.08)*51), 0) or math.max(math.floor(255 - math.abs((i - selected) - math.abs(stuff.offset)/0.08)*51), 0)
					scriptdraw.draw_text(stuff.items[i], reuse_v2(0, 0.005 - 0.08 * (i - selected) + (stuff.offset or 0)), textv2, size / stuff.text_size_rel_to_res, (alpha << 24 | 0xFFFFFF), 0)
				end
			end

			controls.disable_control_action(0, 200, true)
			controls.disable_control_action(0, 172, true)
			controls.disable_control_action(0, 27, true)

			system.wait(0)
		end
	end

	-- Usage: local index, item = selector("Select Player: ", 2, {"Player 1", "Player 2", "Player 3"})
	-- if cancelled returned `index` will be false
	-- `items` has to be in order and starting from 1
	function cheeseUtils.selector(selected_str, speed, index, items)
		index = tonumber(index) or 1
		index = index > 1 and index or 1
		assert(type(items) == "table", "items should be a table")
		local stuff = {
			selected_str = selected_str and tostring(selected_str) or "Select: ",
			items = items,
			selected = tonumber(index) or 1,
			next_selected = 0,
			offset = 0,
			size_offset = 0,
			offset_step = 0.08/(10/(speed or 1)),
			size_step = 0.3/(10/(speed or 1)),
			text_size_rel_to_res = (3686400/(graphics.get_screen_width()*graphics.get_screen_height()))*0.3+0.7,
		}

		local drawThread = menu.create_thread(draw_selector, stuff)

		while key.enter:is_down() do
			system.wait(0)
		end

		while true do
			if key.enter:is_down() then
				break
			end
			if key.backspace:is_down() then
				menu.delete_thread(drawThread)
				while key.backspace:is_down() do
					system.wait(0)
				end
				return false
			end
			if get_key_wait("up") then
				stuff.move = "up"
				stuff.next_selected = stuff.selected - 1
			end
			if get_key_wait("down") then
				stuff.move = "down"
				stuff.next_selected = stuff.selected + 1
			end
			system.wait(0)
		end

		while key.enter:is_down() do
			system.wait(0)
		end

		menu.delete_thread(drawThread)

		return stuff.selected, stuff.items[stuff.selected]
	end
end
--

-- Draw Slider
do
	local reuse_v2 = cheeseUtils.new_reusable_v2()

	function cheeseUtils.draw_slider(pos, width, min, max, value, colorBG, colorActive, colorText, draw_value)
		scriptdraw.draw_rect(pos, width, colorBG)
		local ActiveWidthX = width.x * ((value - min) / (max - min))
		scriptdraw.draw_rect(reuse_v2(pos.x - width.x/2 + ActiveWidthX/2, pos.y), reuse_v2(ActiveWidthX , width.y), colorActive)

		if draw_value then
			local text_size = scriptdraw.get_text_size(tostring(value), 1)
			local size_correction = width.y*2 / scriptdraw.size_pixel_to_rel_y(text_size.y*2) - 0.12
			text_size = text_size * size_correction
			text_size.x = scriptdraw.size_pixel_to_rel_x(text_size.x)
			text_size.y = scriptdraw.size_pixel_to_rel_y(text_size.y)
			scriptdraw.draw_text(tostring(value), reuse_v2(pos.x - text_size.x/2, pos.y + text_size.y/2), reuse_v2(2, 2), size_correction, colorText, 0)
		end
	end
end

-- Use width and height with draw_rect_ext
do
	local v2r = cheeseUtils.new_reusable_v2(4)
	function cheeseUtils.draw_rect_ext_wh(pos, size, color1, color2, color3, color4)
		local halfWdith, halfHeight = size.x/2, size.y/2
		local Bottom = pos.y - halfHeight
		local Top = pos.y + halfHeight
		local Left = pos.x - halfWdith
		local Right = pos.x + halfWdith
		scriptdraw.draw_rect_ext(v2r(Left, Bottom), v2r(Left, Top), v2r(Right, Top), v2r(Right, Bottom), color1, color2, color3, color4)
	end
end

-- Side Window
--[[
Usage example:
	local cheeseUtils = require("CheeseUtilities")

	local window_test = cheeseUtils.new_side_window("test_header", v2(0.5, 0.5))

	local firstField = window_test:add_field("left", "right")

	do
		local timer = utils.time_ms() + 100
		window_test:add_field("idk", "1"):set_update_function(function(field)
			if timer < utils.time_ms() then
				timer = utils.time_ms() + 100
				local fieldValue = tonumber(field.value)
				fieldValue = fieldValue + 1
				if fieldValue > 25 then
					fieldValue = 1
				end
				return fieldValue, fieldValue > 10 and "> 10" or "< 10"
			end
		end)
	end

	window_test:set_position(nil, 0.2)

	window_test:set_rect_color(0xAA000000)

	menu.create_thread(function()
		while true do
			window_test:update()
			window_test:draw()
			system.wait(0)
		end
	end)

	menu.add_feature("hide cheese", "toggle", 0, function(f)
		if f.on then
			window_test:remove_field(window_test:get_field_by_name("cheese"))
			firstField:set_value("right")
		else
			window_test:add_field("cheese", "menu", 2)
			firstField:set_value("cheese enabled")
		end
	end).on = true
]]
do
	local function draw_side_window(self)
		assert(
			type(self.header_text) == "string"
			and type(self.fields) == "table"
			and type(self.pos) == "userdata"
			and type(self.rect_color) == "number"
			and type(self.rect_width) == "number"
			and type(self.text_spacing) == "number"
			and type(self.text_padding) == "number"
			and type(self.text_color) == "number",
			"one or more draw_side_window args were invalid"
		)
		local rect_height = (#self.fields-self.hidden_fields)*self.text_spacing - self.text_spacing + self.last_name_height + 0.02 --+0.0083--+(self.header_on and 0.07125 or 0.02)
		local original_y = self.pos.y--(rect_height/2)
		local header_y = original_y+self.header_height/2+rect_height/2
		local hidden_y_offset = 0


		scriptdraw.draw_rect(self.pos, cheeseUtils.memoize.v2(self.rect_width, rect_height), self.rect_color)
		if self.header_on then
			scriptdraw.draw_rect(cheeseUtils.memoize.v2(self.pos.x, header_y), cheeseUtils.memoize.v2(self.rect_width, self.header_height), self.rect_color)
		end

		local text_size = graphics.get_screen_width()*graphics.get_screen_height()/3686400*0.75+0.25
		-- Header text
		scriptdraw.draw_text(self.header_text, cheeseUtils.memoize.v2(self.pos.x - self.header_text_width/graphics.get_screen_width(), header_y+0.015), cheeseUtils.memoize.v2(2, 2), text_size, self.text_color, 0, 0)
		-- table_of_lines
		for id, field in ipairs(self.fields) do
			if field.hidden then
				hidden_y_offset = hidden_y_offset + 1
			else
				local pos_y = original_y-(id-hidden_y_offset-1)*self.text_spacing+rect_height/2 - self.last_name_height/6 - 0.01 --(self.text_spacing/2.5)
				scriptdraw.draw_text(field.name, cheeseUtils.memoize.v2(self.pos.x-self.rect_width/2+self.text_padding, pos_y), cheeseUtils.memoize.v2(2, 2), text_size, self.text_color, 0, 2)
				scriptdraw.draw_text(field.value, cheeseUtils.memoize.v2(self.pos.x+self.rect_width/2-self.text_padding, pos_y), cheeseUtils.memoize.v2(2, 2), text_size, self.text_color, 16, 2)
			end
		end
	end

	-- field functions
		local function set_name(self, new_name)
			if new_name then
				if self.window.fields[#self.window.fields] == self then
					local text_size = graphics.get_screen_width()*graphics.get_screen_height()/3686400*0.75+0.25
					self.window.last_name_height = scriptdraw.size_pixel_to_rel_y(scriptdraw.get_text_size(new_name, text_size, 0).y)
				end
				self.fields_by_name[self.name] = nil
				self.name = tostring(new_name) or ""
				self.fields_by_name[new_name] = self
			end
		end

		local function set_value(self, value)
			if value then
				self.value = tostring(value)
			end
		end

		local function set_update_function(self, callback)
			self.update_function = callback
		end

		local function update_field(self)
			if self.update_function then
				local value, name = self:update_function()

				self:set_value(value)
				self:set_name(name)
			end
		end

		local function set_hidden(self, bool)
			assert(type(bool) == "boolean", "hidden only accepts boolean value")
			if bool ~= self.hidden then
				self.hidden = bool
				self.window.hidden_fields = self.window.hidden_fields + (bool and 1 or -1)
			end
		end
	--

	---@class field
	---@field name					string
	---@field value					string
	---@field set_name				function
	---@field set_value			 	function
	---@field set_update_function	function
	---@field update				function

	---@param name string
	---@param value string | number
	---@return field
	local function add_field(self, name, value, pos)
		local field = {
			name = name,
			value = value,
			id = pos or #self.fields + 1,
			fields_by_name = self.fields_by_name,
			window = self,
			hidden = false,
			set_name = set_name,
			set_value = set_value,
			set_update_function = set_update_function,
			update = update_field,
			set_hidden = set_hidden
		}
		if pos then
			local prevField = (pos - 1 > 0 and self.fields[pos-1] or true)
			assert(prevField, "Fields have to be in increments of 1, for example (1, 2, 5) will not work")
			if self.fields[pos] and prevField then
				table.insert(self.fields, pos, field)
			elseif prevField then
				self.fields[pos] = field
			end
		else
			self.fields[#self.fields + 1] = field
			local text_size = graphics.get_screen_width()*graphics.get_screen_height()/3686400*0.75+0.25
			self.last_name_height = scriptdraw.size_pixel_to_rel_y(scriptdraw.get_text_size(name, text_size, 0).y)
		end
		self.fields_by_name[name] = field

		return field
	end

	local function remove_field(self, field)
		if field and self.fields[field.id] then
			table.remove(self.fields, field.id)
			self.fields_by_name[field.name] = nil

			return true
		end

		return false
	end

	local function get_field_by_name(self, name)
		return self.fields_by_name[name]
	end

	local function update(self)
		for _, field in pairs(self.fields) do
			field:update()
		end
	end

	local function set_position(self, x, y)
		self.pos.x = tonumber(x) or self.pos.x
		self.pos.y = tonumber(y) or self.pos.y
	end

	local function set_header_text(self, text)
		text = tostring(text)
		self.header_text = text
		self.header_on = text ~= ""
		local text_size = graphics.get_screen_width()*graphics.get_screen_height()/3686400*0.75+0.25
		self.header_text_width = scriptdraw.get_text_size(self.header_text, text_size, 0).x
	end

	local set_functions = {}
	for _, field in ipairs({'text_padding', 'text_spacing', 'rect_width', 'rect_color', 'text_color'}) do
		set_functions[field] = function(self, num)
			num = tonumber(num)
			assert(num, field.." value has to be a number")
			self[field] = num
		end
	end

	---@class window
	---@field draw				function
	---@field update			function
	---@field add_field			function
	---@field remove_field		function
	---@field set_position		function
	---@field get_field_by_name	function
	---@field set_text_padding	function
	---@field set_text_spacing	function
	---@field set_rect_width	function
	---@field set_rect_color	function
	---@field set_text_color	function
	---@field set_header_text	function
	---@field set_hidden		function
	---@field header_text		string
	---@field fields			table
	---@field fields_by_name	table
	---@field pos				v2
	---@field rect_color		uint32_t
	---@field rect_width		float
	---@field text_spacing		float
	---@field text_padding		float
	---@field text_color		uint32_t

	---@return window
	function cheeseUtils.new_side_window(header_text, pos, rect_color, rect_width, text_spacing, text_padding, text_color)
		local text_size = graphics.get_screen_width()*graphics.get_screen_height()/3686400*0.75+0.25

		local window = {
			header_text = header_text or "",
			header_on = header_text ~= "",
			fields = {},
			fields_by_name = {},
			pos = pos or v2(),
			rect_color = rect_color or 0xFF000000,
			rect_width = rect_width or 0.2,
			text_spacing = text_spacing or 0.047,
			text_padding = text_padding or 0.01,
			text_color = text_color or 0xFFFFFFFF,
			header_height = 0.06125,
			header_text_width = scriptdraw.get_text_size(header_text, text_size, 0).x,
			hidden_fields = 0,
		}

		window.draw = draw_side_window
		window.update = update
		window.add_field = add_field
		window.remove_field = remove_field
		window.set_position = set_position
		window.get_field_by_name = get_field_by_name
		window.set_header_text = set_header_text
		for name, func in pairs(set_functions) do
			window['set_'..name] = func
		end

		return window
	end
end


-- Range Converter
do
	---@class range_converter
	---@field call function

	local function convert_range(self, value)
		return self.base_value + (value * self.step)
	end
	local Metatable = {__call = convert_range}

	--[[

		local rng_cnvrt = cheeseUtils.create_range_converter(0, 1, 0, 100)
		rng_cnvrt(5) -- returns 500
	]]
	---@return range_converter
	function cheeseUtils.create_range_converter(original_range_min, original_range_max, convert_range_min, convert_range_max)
		local stuff = {}

		local adjusted_max_original = original_range_max-original_range_min
		local adjusted_max_convert = convert_range_max-convert_range_min

		stuff.base_value = (0-original_range_min)/adjusted_max_original*adjusted_max_convert+convert_range_min
		stuff.step = (1-original_range_min)/adjusted_max_original*adjusted_max_convert+convert_range_min - stuff.base_value

		setmetatable(stuff, Metatable)

		return stuff
	end
end

-- Text Wrap
do
	---@param text string
	---@param font int
	---@param scale float
	---@param relWidth float
	function cheeseUtils.wrap_text(text, font, scale, relWidth)
		local spaceSize = scriptdraw.get_text_size(". .", scale, font).x - scriptdraw.get_text_size("..", scale, font).x
		local lines = {}
		for line, manualNewLines in text:gmatch("([^\r\n]+)([\r\n]*)") do
			local newline
			local lineSize = scriptdraw.get_text_size(line, scale, font)

			if scriptdraw.size_pixel_to_rel_x(lineSize.x) > relWidth then
				local length = 0
				newline = {}
				for word in line:gmatch("[^%s-\\,]+[%s-\\,]*") do
					local relx = scriptdraw.size_pixel_to_rel_x(scriptdraw.get_text_size(word, scale, font).x)
					local spaceRelx = word:gsub("%S", "")
					spaceRelx = scriptdraw.size_pixel_to_rel_x(#spaceRelx*spaceSize)
					if length + relx > relWidth then
						newline[#newline+1] = "\n"
						length = 0
					end
					length = length + relx + spaceRelx
					newline[#newline+1] = word
				end

				line = table.concat(newline)
			end

			lines[#lines+1] = line..(manualNewLines or "")
		end

		return table.concat(lines)
	end
end

-- Convert Colors
do
	function cheeseUtils.convert_rgba_to_int(r, g, b, a)
		if type(r) == "table" then
			local colorTable = r
			r = colorTable.r or colorTable[1]
			g = colorTable.g or colorTable[2]
			b = colorTable.b or colorTable[3]
			a = colorTable.a or colorTable[4]
		end
		if not a then
			a = 255
		end
		assert(r and g and b, "one or more of the r, g, b values is invalid")
		assert((a <= 255 and a >= 0) and (b <= 255 and b >= 0) and (g <= 255 and g >= 0) and (r <= 255 and r >= 0), "rgba values cannot be more than 255 or less than 0")
		return (a << 24) | (b << 16) | (g << 8) | r
	end

	local conversionValues = {a = 24, b = 16, g = 8, r = 0}
	function cheeseUtils.convert_int_to_rgba(...)
		local int, val1, val2, val3, val4 = ...
		local values = {val1, val2, val3, val4}

		for k, v in pairs(values) do
			values[k] = int >> conversionValues[v] & 0xff
		end
		return table.unpack(values)
	end
end

-- Round Numbers
function cheeseUtils.round_num(n, digits)
	n = digits and n * (10 * digits) or n
	n = n + 0.5
	n = n // (digits and 10 * digits or 1)
	return n
end

-- Hue Saturation Value TO BGR
---@return int Blue, int Green, int Red
function cheeseUtils.hsv_to_rgb(hue, sat, val)
	sat, val = sat or 1, val or 1
	local k = (hue / 60)

	local rgb = {}
	for n = 1, 5, 2 do
		local k = (n + k) % 6
		rgb[#rgb+1] = cheeseUtils.round_num((val - val * sat * math.max(0, math.min(k, 4-k, 1))) * 255)
	end

	return table.unpack(rgb)
end

-- RGB TO HSV
---@return number hue, number saturation, number value
function cheeseUtils.rgb_to_hsv(r, g, b)
	local max = math.max(r, g, b)
	local min = math.min(r, g, b)

	local chroma = max - min
	local saturation = min < 255 and (chroma > 0 and chroma / max or 1) or 0
	local value = max / 255
	local hue = 0

	local sub
	local num
	if chroma > 0 then
		if max == r then
			sub = g - b
			num = 0
		elseif max == g then
			sub = b - r
			num = 2
		elseif max == b then
			sub = r - g
			num = 4
		end

		hue = 60 * (num + sub / chroma)
		hue = hue < 0 and hue + 360 or hue
	end

	return hue, saturation, value
end

-- Mouse Sliders
do
	cheeseUtils.mouse = {}

	local trustNatives = menu.is_trusted_mode_enabled(4)

	local function controls_get_normal(...)
		return math.max(trustNatives and native.call(0x11E65974A982637C, ...):__tonumber() or 0, controls.get_control_normal(...))
	end

	local function control_is_just_pressed(...)
		return controls.is_disabled_control_just_pressed(...) or controls.is_control_just_pressed(...)
	end

	local function control_is_pressed(...)
		return controls.is_disabled_control_pressed(...) or controls.is_control_pressed(...)
	end

	local disableControls = {
		1,
		2,
		24,
		69,
		92,
		106,
		142,
		176,
		257,
		329,
		346,
	}

	local mousev2 = v2()
	local mousev2r = cheeseUtils.new_reusable_v2(2)
	function cheeseUtils.mouse.enable(draw)
		for _, control in ipairs(disableControls) do
			controls.disable_control_action(0, control, true)
		end
		native.call(0x5E6CC07646BBEAB8, player.player_id(), true) -- DISABLE_PLAYER_FIRING

		mousev2.x, mousev2.y = controls_get_normal(0, 239)*2-1, controls_get_normal(0, 240)*-2+1-scriptdraw.size_pixel_to_rel_y(20)
		if draw then
			scriptdraw.draw_triangle(
				mousev2,
				mousev2r(mousev2.x, mousev2.y+scriptdraw.size_pixel_to_rel_y(20)),
				mousev2r(mousev2.x+scriptdraw.size_pixel_to_rel_x(13), mousev2.y),
				0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF
			)
		end
		return mousev2
	end

	local slider_types = {
		x = 1,
		y = 2,
		xy = 3
	}

	local function set_pos(self, pos)
		self.pos = pos
		self.range['hitbox_x'] = cheeseUtils.create_range_converter(pos.x+self.hitbox.x/2, pos.x-self.hitbox.x/2, 0, 1)
		self.range['hitbox_y'] = cheeseUtils.create_range_converter(pos.y+self.hitbox.y/2, pos.y-self.hitbox.y/2, 0, 1)

		local is_xy = self.type & 3 == 3
		if self.type & 1 ~= 0 then
			self.range['x'] = cheeseUtils.create_range_converter(pos.x+self.size.x/2, pos.x-self.size.x/2, 0, 1)
			self.range['inverse_x'] = cheeseUtils.create_range_converter(0, 1, pos.x+self.size.x/2, pos.x-self.size.x/2)
		end
		if self.type >> 1 & 1 ~= 0 then
			self.range['y'] = cheeseUtils.create_range_converter(pos.y+self.size.y/2, pos.y-self.size.y/2, 0, 1)
			self.range['inverse_y'] = cheeseUtils.create_range_converter(0, 1, pos.y+self.size.y/2, pos.y-self.size.y/2)
		end
	end

	local function set_draw_function(self, func)
		self.draw = func
	end

	local function default_draw(self)
		scriptdraw.draw_rect(self.pos, self.size, 0xFFAAAAAA)

		local x, y = self:get_screen_pos()
		scriptdraw.draw_circle(self.v2r(x, y), 0.01, 0xFFFFFFFF)
	end

	local function update_slider(self, disable_control)
		self:draw()

		local mouse_x, mouse_y = controls_get_normal(0, 239)*2-1, controls_get_normal(0, 240)*-2+1
		if control_is_just_pressed(0, 142) and not disable_control then
			local x = self.range.hitbox_x(mouse_x)
			local y = self.range.hitbox_y(mouse_y)

			x = 0 <= x and x <= 1
			y = 0 <= y and y <= 1
			self.within_hitbox = x and y
		elseif not control_is_pressed(0, 142) then
			self.within_hitbox = false
		end

		if self.within_hitbox then
			local x
			if self.type & 1 ~= 0 then
				x = self.range.x(mouse_x)
				x = x > 0 and x or 0
				x = x < 1 and x or 1
			end

			local y
			if self.type >> 1 & 1 ~= 0 then
				y = self.range.y(mouse_y)
				y = y > 0 and y or 0
				y = y < 1 and y or 1
			end

			self.value.x, self.value.y = x, y
			return x or y, y
		end
	end

	---@return float x x|y 0, 1
	---@return float y y|nil 0, 1
	local function get_value(self)
		return self.value.x or self.value.y, self.value.y
	end

	---@return float x, float y
	local function get_screen_pos(self)
		local x = (self.type & 1 ~= 0 and self.value.x) and self.range.inverse_x(self.value.x) or self.pos.x -- x screen pos of value
		local y = (self.type >> 1 & 1 ~= 0 and self.value.y) and self.range.inverse_y(self.value.y) or self.pos.y -- y screen pos of value

		return x, y
	end

	---@class 					mouse_slider
	---@field type 				number
	---@field set_pos 			function
	---@field set_draw_function function
	---@field draw 				function
	---@field update 			function
	---@field get_screen_pos  	function
	---@field get_value  		function
	---@field within_hitbox		bool
	---@field pos				v2
	---@field hitbox			v2
	---@field size				v2
	---@field value				v2


	---@param sType 	string 		"'x', 'y', 'xy'"
	---@param pos 		v2
	---@param hitbox	v2
	---@param size 		v2
	---@param default_x number|nil 		x|y
	---@param default_y number|nil 		x|y
	---@return 			mouse_slider
	local function mouse_slider(sType, pos, hitbox, size, default_x, default_y)
		sType = slider_types[sType]
		--local is_xy = sType & 3 == 3
		local stuff = {
			within_hitbox = false,
			type = sType,
			pos = pos,
			hitbox = hitbox,
			size = size,
			v2r = cheeseUtils.new_reusable_v2(4),
			value = {
				x = sType & 1 ~= 0 and (default_x or 0),
				y = sType >> 1 & 1 ~= 0 and (default_y or 0)
			},
			range = {},
			set_pos = set_pos,
			set_draw_function = set_draw_function,
			draw = default_draw,
			update = update_slider,
			get_screen_pos = get_screen_pos,
			get_value = get_value,
		}

		stuff.range['hitbox_x'] = cheeseUtils.create_range_converter(pos.x+hitbox.x/2, pos.x-hitbox.x/2, 0, 1)
		stuff.range['hitbox_y'] = cheeseUtils.create_range_converter(pos.y+hitbox.y/2, pos.y-hitbox.y/2, 0, 1)

		if sType & 1 ~= 0 then
			stuff.range['x'] = cheeseUtils.create_range_converter(pos.x+size.x/2, pos.x-size.x/2, 0, 1)
			stuff.range['inverse_x'] = cheeseUtils.create_range_converter(0, 1, pos.x+size.x/2, pos.x-size.x/2)
		end
		if sType >> 1 & 1 ~= 0 then
			stuff.range['y'] = cheeseUtils.create_range_converter(pos.y+size.y/2, pos.y-size.y/2, 0, 1)
			stuff.range['inverse_y'] = cheeseUtils.create_range_converter(0, 1, pos.y+size.y/2, pos.y-size.y/2)
		end

		return stuff
	end

	---@param pos 		v2
	---@param hitbox	v2
	---@param size 		v2
	---@param default_x number|nil 		x
	function cheeseUtils.mouse.horizontal_slider(pos, hitbox, size, default_x)
		return mouse_slider("x", pos, hitbox, size, default_x)
	end

	---@param pos 		v2
	---@param hitbox	v2
	---@param size 		v2
	---@param default_y number|nil 		y
	function cheeseUtils.mouse.vertical_slider(pos, hitbox, size, default_y)
		return mouse_slider("y", pos, hitbox, size, nil, default_y)
	end

	---@param pos 		v2
	---@param hitbox	v2
	---@param size 		v2
	---@param default_x number|nil 		x
	---@param default_y number|nil 		y
	function cheeseUtils.mouse.xy_slider(pos, hitbox, size, default_x, default_y)
		return mouse_slider("xy", pos, hitbox, size, default_x, default_y)
	end
end

-- Color Picker
--[[
	Example:
		local status, ABGR, red, green, blue, alpha
		repeat
			status, ABGR, red, green, blue, alpha = cheeseUtils.pick_color()
			if status == 2 then
				return
			end
			system.wait(0)
		until status == 0
]]
do
	local alpha_slider
	local hue_slider
	local color_picker = cheeseUtils.mouse.xy_slider(
		v2(),
		v2(scriptdraw.size_pixel_to_rel_x(256), scriptdraw.size_pixel_to_rel_y(256)),
		v2(scriptdraw.size_pixel_to_rel_x(256), scriptdraw.size_pixel_to_rel_y(256))
	)
	color_picker:set_draw_function(function(slider)
		local hue = (1-hue_slider.value.y)*360
		local b, g, r = cheeseUtils.hsv_to_rgb(hue)
		local color = cheeseUtils.convert_rgba_to_int(r, g, b)

		cheeseUtils.draw_rect_ext_wh(slider.pos, slider.size, 0xFFFFFFFF, 0xFFFFFFFF, color, color)
		cheeseUtils.draw_rect_ext_wh(slider.pos, slider.size, 0xFF000000, 0, 0, 0xFF000000)

		local screen_pos = slider.v2r(slider:get_screen_pos())

		local val = 1 - slider.value.y
		local sat = 1 - slider.value.x
		b, g, r = cheeseUtils.hsv_to_rgb(hue, sat, val)
		slider.color = cheeseUtils.convert_rgba_to_int(r, g, b, (1-alpha_slider.value.x)*255//1)
		slider.colors[1] = r
		slider.colors[2] = g
		slider.colors[3] = b
		slider.colors[4] = (1-alpha_slider.value.x)*255//1

		scriptdraw.draw_circle(screen_pos, 0.0125, 0xFFFFFFFF)
		scriptdraw.draw_circle(screen_pos, 0.01, slider.color)
	end)
	color_picker.color = 0
	color_picker.colors = {}

	local size = v2(scriptdraw.size_pixel_to_rel_x(48), scriptdraw.size_pixel_to_rel_y(256))
	hue_slider = cheeseUtils.mouse.vertical_slider(v2(color_picker.pos.x+color_picker.size.x/2+scriptdraw.size_pixel_to_rel_x(50), color_picker.pos.y), size, size, 0)
	hue_slider.hue = 0

	local hue_gradient = {}
	local hue_y = hue_slider.pos.y-hue_slider.size.y/2+scriptdraw.size_pixel_to_rel_y(23)
	for i = 0, 6, 1 do
		local b, g, r = cheeseUtils.hsv_to_rgb(i*60)
		local bottom = cheeseUtils.convert_rgba_to_int(r, g, b)

		b, g, r = cheeseUtils.hsv_to_rgb((i+1)*60)
		local top = cheeseUtils.convert_rgba_to_int(r, g, b)

		hue_gradient[#hue_gradient+1] = {bottom = bottom, top = top, y = hue_y}
		hue_y = hue_y + scriptdraw.size_pixel_to_rel_y(42)
	end

	local hue_size = v2(scriptdraw.size_pixel_to_rel_x(48), scriptdraw.size_pixel_to_rel_y(46))
	hue_slider:set_draw_function(function(slider)
		for i = 1, 6 do
			local hue_table = hue_gradient[i]
			cheeseUtils.draw_rect_ext_wh(slider.v2r(slider.pos.x, hue_table.y), hue_size, hue_table.bottom, hue_table.top, hue_table.top, hue_table.bottom)
		end
		scriptdraw.draw_rect(slider.v2r(slider.pos.x, slider.range.inverse_y(slider.value.y)), slider.v2r(slider.size.x+scriptdraw.size_pixel_to_rel_x(6), scriptdraw.size_pixel_to_rel_y(10)), 0xFFFFFFFF)

		local b, g, r = cheeseUtils.hsv_to_rgb((1-slider.value.y)*360)
		local color = cheeseUtils.convert_rgba_to_int(r, g, b)
		scriptdraw.draw_rect(slider.v2r(slider.pos.x, slider.range.inverse_y(slider.value.y)), slider.v2r(slider.size.x, scriptdraw.size_pixel_to_rel_y(6)), color)
	end)

	local hex = ""
	local lastIntColor = 0
	local color_pos = v2((color_picker.pos.x+hue_slider.pos.x/2.4)/2, color_picker.pos.y-color_picker.size.y/2-scriptdraw.size_pixel_to_rel_y(60))
	local color_size = v2(scriptdraw.size_pixel_to_rel_x(330), scriptdraw.size_pixel_to_rel_y(57))
	local text_pos = v2(color_pos.x+scriptdraw.size_pixel_to_rel_x(10), color_pos.y)

	alpha_slider = cheeseUtils.mouse.horizontal_slider(
		v2(color_pos.x, color_pos.y+scriptdraw.size_pixel_to_rel_y(45)),
		v2(scriptdraw.size_pixel_to_rel_x(330), scriptdraw.size_pixel_to_rel_y(15)),
		v2(scriptdraw.size_pixel_to_rel_x(330), scriptdraw.size_pixel_to_rel_y(5)),
		0
	)

	saturation_slider = cheeseUtils.mouse.horizontal_slider(
		v2(color_picker.pos.x, color_picker.pos.y+color_picker.size.y/2+scriptdraw.size_pixel_to_rel_y(15)),
		v2(scriptdraw.size_pixel_to_rel_x(256), scriptdraw.size_pixel_to_rel_y(15)),
		v2(scriptdraw.size_pixel_to_rel_x(256), scriptdraw.size_pixel_to_rel_y(5))
	)

	value_slider = cheeseUtils.mouse.vertical_slider(
		v2(color_picker.pos.x-color_picker.size.x/2-scriptdraw.size_pixel_to_rel_x(15), color_picker.pos.y),
		v2(scriptdraw.size_pixel_to_rel_x(15), scriptdraw.size_pixel_to_rel_y(256)),
		v2(scriptdraw.size_pixel_to_rel_x(5), scriptdraw.size_pixel_to_rel_y(256))
	)

	local running = false
	---@return integer status, uint32_t|nil color, int|nil red, int|nil green, int|nil blue, int|nil alpha
	function cheeseUtils.pick_color(r, g, b, a)
		if not running and (r and g and b) then
			local hue, sat, val = cheeseUtils.rgb_to_hsv(r, g, b)
			hue_slider.value.y = 1-hue/360
			color_picker.value.x = 1-sat
			saturation_slider.value.x = 1-sat
			color_picker.value.y = 1-val
			value_slider.value.y = 1-val
			alpha_slider.value.x = a and 1-a/255 or 255
		end

		if cheeseUIdata then
			cheeseUIdata.inputBoxOpen = true
		end
		running = true
		--menu.set_menu_can_navigate(false)

		controls.disable_control_action(0, 200, true)

		if lastIntColor ~= color_picker.color then
			local r, g, b = cheeseUtils.convert_int_to_rgba(color_picker.color, "r", "g", "b")
			local intColor = r << 16 | g << 8 | b
			hex = string.format("%X", intColor)
			hex = "#"..string.rep("0", 6 - #hex)..hex
		end

		scriptdraw.draw_rect(color_pos, color_size, color_picker.color)
		scriptdraw.draw_text(hex, text_pos, color_size, 1, 0xFFFFFFFF, 2)

		local sat = saturation_slider:update()
		local val = value_slider:update()

		color_picker.value.x = sat or color_picker.value.x
		color_picker.value.y = val or color_picker.value.y

		hue_slider:update()
		sat, val = color_picker:update()

		saturation_slider.value.x = sat or saturation_slider.value.x
		value_slider.value.y = val or value_slider.value.y

		alpha_slider:update()
		cheeseUtils.mouse.enable(true)

		if cheeseUtils.get_key(0x0D):is_down() or cheeseUtils.get_key(0x1B):is_down() or cheeseUtils.get_key(0x08):is_down() then
			local success = cheeseUtils.get_key(0x0D):is_down()
			while cheeseUtils.get_key(0x0D):is_down() or cheeseUtils.get_key(0x1B):is_down() or cheeseUtils.get_key(0x08):is_down() do
				controls.disable_control_action(0, 200, true)
				system.wait(0)
			end
			controls.disable_control_action(0, 200, true)
			if cheeseUIdata then
				cheeseUIdata.inputBoxOpen = false
			end
			running = false
			--menu.set_menu_can_navigate(true)
			alpha_slider.value.x = 0
			hue_slider.hue = 0
			hue_slider.value.y = 0
			color_picker.value.x = 0
			color_picker.value.y = 0
			if not success then
				return 2
			end
			return 0, color_picker.color, table.unpack(color_picker.colors)
		end

		return 1, color_picker.color, table.unpack(color_picker.colors)
	end
end

return cheeseUtils