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

	local speed_modifier = 1.5
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
			local max = selected + 4 <= #stuff.items and selected + 4 or #stuff.items
			for i = min, max do
				if stuff.items[i] then
					local size = i == selected and 1.3 or 1
					size = i == stuff.next_selected and size + stuff.size_offset or i == selected and size - stuff.size_offset or size
					scriptdraw.draw_text(stuff.items[i], reuse_v2(0, 0.005 - 0.08 * (i - selected) + (stuff.offset or 0)), textv2, size / stuff.text_size_rel_to_res, (255 - ((i - selected > 0 and i - selected or -(i - selected)) * 51) << 24 | 0xFFFFFF), 0)
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
	function cheeseUtils.selector(selected_str, index, items)
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
			offset_step = 0.08/(10/speed_modifier),
			size_step = 0.3/(10/speed_modifier),
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

return cheeseUtils
