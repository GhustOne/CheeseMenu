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

	return function(x, y)
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
	local function convert_range(self, value)
		return self.base_value + (value * self.step)
	end
	local Metatable = {__call = convert_range}

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

return cheeseUtils
