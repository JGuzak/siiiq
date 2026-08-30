local MAX_X=grid_size_x()
local MAX_Y=grid_size_y()
local GRID_VARIANT=(MAX_Y==16 and MAX_X==16) and "Zero" or (MAX_Y==8 and MAX_X==16) and "One"
local GRID_VERTICAL_OFFSET=(GRID_VARIANT=="Zero") and 8 or 0
local MAX_BRIGHTNESS = 15
local NUM_ACCESS_BUTTONS = 4
local menu_access_buttons_held=0
local last_menu_button_press_time=nil
local single_page="faders"
local selected_fader=1


-- Track when a button is pressed down vs when it is released
local last_button = { 1, 1 }
local last_button_press_time = nil
local MIN_HOLD_TIME = 1.0

-- Fader positions are 0.0 to 1.0 and should be scaled to MIDI CC ranges/LED positions.
local fader_pos = {0.5, 0.55, 0.56, 0.57, 0.58, 0.6, 0.8, 0.6, 0.4, 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0}

function init()
	render_grid()
end

function toggle_page()
	if single_page == "faders" then
		single_page="settings"
	else
		single_page="faders"
	end
end

function handle_menu_access_button_press(z)
	if z==1 then
		if last_menu_button_press_time ==nil then
			last_menu_button_press_time=get_time()
		end

		if last_menu_button_press_time - get_time() < 20 then
			menu_access_buttons_held = clamp(menu_access_buttons_held+1,0,NUM_ACCESS_BUTTONS)
			last_menu_button_press_time = get_time()
		end
	else
		menu_access_buttons_held = clamp(menu_access_buttons_held-1,0,NUM_ACCESS_BUTTONS)
	end
end

function handle_track_select_button_press(x)
 selected_fader = clamp(x, 0, MAX_X)
end

function handle_fader_position_change(x,y, y_offset, z)
	-- TODO: Make the button interaction more fun with slews

	-- Button press and hold should trigger a continuous slew at a fast, slow,
	-- or instant rate.

	-- Alternatively, whatever button is held should be the target point of the slew,
	-- once pad is released, the slew should stop.
	-- Double tap middle, bottom, and top pads should instantaneously jump to middle,
	-- bottom, or top values.
	-- This will be easier to implement vs the first option.

	-- Naive way to do this, hard value jumps:
	-- 1 Set to Max
	-- 2 Large step increase by static amount
	-- 3 Small step increase by static amount
	-- 4 Set to middle
	-- 5 Small step decrease by static amount
	-- 6 Large step decrease by static amount
	-- 7 Set to Min
	if y == 1 then
		fader_pos[x] = 1.0
	elseif y == 2 then
		fader_pos[x] = clamp(fader_pos[x] + 0.1, 0.0, 1.0)
	elseif y == 3 then
		fader_pos[x] = clamp(fader_pos[x] + 0.05, 0.0, 1.0)
	elseif y == 4 then
		fader_pos[x] = 0.5
	elseif y == 5 then
		fader_pos[x] = clamp(fader_pos[x] - 0.05, 0.0, 1.0)
	elseif y == 6 then
		fader_pos[x] = clamp(fader_pos[x] - 0.1, 0.0, 1.0)
	elseif y == 7 then
		fader_pos[x] = 0.0
	end

end

function event_grid(x,y,z)
	if GRID_VARIANT == "One" then
		if y==MAX_Y then
			handle_menu_access_button_press(z)
			if z == 1 then
				handle_track_select_button_press(x)
			end
		else
			handle_fader_position_change(x, y, 0, z)
		end
		if menu_access_buttons_held==NUM_ACCESS_BUTTONS then
			if z==1 then
				toggle_page()
			end
		end
	end

	-- TODO: Fix this
	-- Move fader position relative to what Y value is pressed; farther from middle, larger movement.
	-- fader_y = y - GRID_VERTICAL_OFFSET
	-- if fader_y > 4 then
	-- 	-- Move fader position down
	-- 	scale = linlin(fader_y - 4, 1, 4, -4, -1)
	-- else
	-- 	-- Move fader position up
	-- 	scale = fader_y
	-- end

	-- if z == 1 then
	-- 	-- new_pos = linlin(, 1, 8, 0.0, 1.0)
	-- 	new_pos = clamp(fader_pos[x] + (0.01 * scale), 0.0, 1.0)
	-- 	fader_pos[x] = new_pos
	-- 	print("new position: " .. new_pos)
	-- 	print("x: " .. x .. " y: " .. y .. " z: " .. z .. " fader position: " .. fader_pos[x])
	-- end

	render_grid()
end

function scale_fader_led_position(raw_fader_pos)
	return round()
end

function render_fader_position(fader_index, y_offset)
	-- fader position leds are 7 pads tall
	for i = 1, 7 do
		brightness = 0
		if i == 4 then brightness = 2 end
		grid_led(fader_index, i + y_offset, brightness)
	end

	-- Aliased position
	fader_position = round(linlin(fader_pos[fader_index], 0.0, 1.0, 7.0, 1.0), 1)
	-- print("fader: " .. fader_index .. " position: " .. fader_position)
	grid_led(fader_index, fader_position, MAX_BRIGHTNESS)

	-- TODO: Fix this
	-- Anti-alias position by adjusting pad brightness if position is between one of the 8 steps.
	-- scaled_position = round(linlin(fader_pos[fader_index], 0.0, 1.0, 8.0, 1.0), 0.001)

	-- remainder = math.fmod(scaled_position, 1)

	-- if remainder ~= 0 then
	-- 	-- Grid is oriented upside down. Top row is index 1
	-- 	middle_y = round(scaled_position - remainder, 1)
	-- 	-- upper_y = middle_y - 1
	-- 	lower_y = middle_y + 1
		
	-- 	-- Brightness range 15 to 5
	-- 	middle_brightness = round(linlin(remainder, 1.0, 0.0, 15.0, 0.0), 1)
	-- 	lower_brightness = round(linlin(remainder, 0.0, 1.0, 15.0, 0.0), 1)

	-- 	-- grid_led(fader_index, upper_y, upper_brightness)
	-- 	grid_led(fader_index, middle_y, middle_brightness)
	-- 	grid_led(fader_index, lower_y, lower_brightness)
	-- else
	-- 	grid_led(fader_index, round(scaled_position, 1), MAX_BRIGHTNESS)
	-- end
	-- print("middle_y: " .. middle_y .. " remainder: " .. remainder)
end

function render_fader_select_bar(y_pos)
	for x=1, MAX_X do
		brightness = 3

		if selected_fader == x then
			brightness = MAX_BRIGHTNESS
		end

		grid_led(x, y_pos, brightness)
	end
end

function render_page(y_offset, name)
	if name == "settings" then
		-- for x=1, MAX_X do
		-- 	local brightness = 0
		-- 	if x == selected_fader then
		-- 		brightness = MAX_BRIGHTNESS
		-- 	end
		-- 	grid_led(x,8+y_offset,brightness)
		-- end
		for x=1, MAX_X do
			for y=1, 8 + y_offset - 1 do
				grid_led(x, y, 4)
			end
		end
	elseif name == "faders" then
		for fader = 1, MAX_X do
			-- Calculate each fader position
			render_fader_position(fader, y_offset)
		end
	end
end

function render_grid()
	-- grid_led_all(0)
	if GRID_VARIANT == "One" then
		render_fader_select_bar(MAX_Y)
		render_page(GRID_VERTICAL_OFFSET, single_page)
	elseif GRID_VARIANT == "Zero" then
		-- render_page(0, "faders")
		-- render_fader_select_bar(8)
		-- render_fader_select_bar(9)
		-- render_page(GRID_VERTICAL_OFFSET, "settings")
	end
	grid_refresh()
end

init()