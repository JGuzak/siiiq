local MAX_X=grid_size_x()
local MAX_Y=grid_size_y()
local HALF_X=MAX_X/2
local HALF_Y=MAX_Y/2
local GRID_VARIANT=(MAX_Y==16 and MAX_X==16) and "Zero" or (MAX_Y==8 and MAX_X==16) and "One"
local GRID_VERTICAL_OFFSET=(GRID_VARIANT=="Zero") and 8 or 0
local MAX_BRIGHTNESS = 15
local NUM_ACCESS_BUTTONS = 4
local menu_access_buttons_held=0
local last_menu_button_press_time=nil
local single_page="slide"
local selected_fader=1

-- Track when a button is pressed down vs when it is released (?)
local last_button = { 1, 1 }
local last_button_press_time = nil
local MIN_HOLD_TIME = 1.0

local SLEW_SPEED = 0.5

-- Fader positions are 0.0 to 1.0 and should be scaled to MIDI CC ranges/LED positions.
local fader_pos = {0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.4, 0.3, 0.2, 0.1, 0.0}
local fader_slew_ids = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil}

function init()
	render_grid()
end

function toggle_page()
	if single_page == "slide" then
		single_page="settings"
	else
		single_page="slide"
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

function handle_track_select_button_press(x, z)
	if z == 1 then
		selected_fader = clamp(x, 0, MAX_X)
	end
end

function handle_fader_tune_press(x, y, z)
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
		fader_pos[x] = clamp(fader_pos[x] + 0.04, 0.0, 1.0)
	elseif y == 3 then
		fader_pos[x] = clamp(fader_pos[x] + 0.025, 0.0, 1.0)
	elseif y == 4 then
		fader_pos[x] = 0.5
	elseif y == 5 then
		fader_pos[x] = clamp(fader_pos[x] - 0.025, 0.0, 1.0)
	elseif y == 6 then
		fader_pos[x] = clamp(fader_pos[x] - 0.04, 0.0, 1.0)
	elseif y == 7 then
		fader_pos[x] = 0.0
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
end

function handle_fader_slide_press(x, y, z)
	-- When a button is pressed, that becomes the slew endpoint
	-- The slew continues until the button is released or it hits the end position
	-- Pressing two values on a fader will move the target position to the middle between the pressed pads.

	new_pos = 0.8

	if z == 1 then
		if fader_slew_ids[x] == nil then
			fader_slew_ids[x] = slew.new(function () end, fader_pos[x], new_pos, SLEW_SPEED, 1)
		else
	
		end
		
	else
		slew.stop(fader_slew_ids[x])
		fader_slew_ids[x] = nil
	end
end

function handle_fader_settings_press(x, y, z)
	-- TODO: Implement this later
end

function event_grid(x, y, z)
	print("x: " .. x .. " y: " .. y .. " z: " .. z)
	if GRID_VARIANT == "One" then
		if y == MAX_Y then
			handle_menu_access_button_press(z)
			handle_track_select_button_press(x, z)
		else
			handle_fader_slide_press(x, y, z)
			-- handle_fader_tune_press(x, y, z)
		end
		if menu_access_buttons_held==NUM_ACCESS_BUTTONS then
			if z==1 then
				toggle_page()
			end
		end
	elseif GRID_VARIANT == "Zero" then
		if y >= HALF_Y and y <= HALF_Y + 1 then
			handle_menu_access_button_press(z)
			handle_track_select_button_press(x, z)
		elseif y < HALF_Y then
			handle_fader_tune_press(x, y, z)
		else
			handle_fader_slide_press(x, y - HALF_Y - 2, z)
			-- handle_fader_settings_press(x, y, z)
		end
	end

	render_grid()
end

function render_fader_slide_position(fader_index, y_offset)
	-- fader position leds are 7 pads tall
	for i = 1, 7 do
		brightness = 0
		if i == 4 then brightness = 2 end
		grid_led(fader_index, i + y_offset, brightness)
	end

	-- Anti-alias position by adjusting pad brightness if position is between one of the 8 steps.
	fader_position = linlin(fader_pos[fader_index], 0.0, 1.0, 7.0, 1.0) + y_offset

	-- if remainder ~= 0 then
	scaled_position = round(linlin(fader_pos[fader_index], 0.0, 1.0, 7.0, 1.0), 0.001)
	remainder = math.fmod(scaled_position, 1)
	middle_y = round(scaled_position - remainder, 1) + y_offset
	-- Brightness range 15 to 5

	-- TODO: Fix the scaling here. Behavior is not quite right
	upper_brightness = round(linlin(remainder, 0.0, 1.0, 7.0, 0.0), 1)
	middle_brightness = round(linlin(remainder, 0.0, 1.0, 15.0, 0.0), 1)
	lower_brightness = round(linlin(remainder, 0.0, 1.0, 0.0, 7.0), 1)
	
	print("fader: " .. fader_index .. " up: " .. upper_brightness .. " mid: " .. middle_brightness .. " low: " .. lower_brightness)
	
	-- Grid is oriented upside down. Top row is index 1
	if fader_position > 2 + y_offset then
		-- Lower pad brightness
		grid_led(fader_index, middle_y + 1, lower_brightness)
	end
	if fader_position < 6 + y_offset then
		-- Upper pad brightness
		grid_led(fader_index, middle_y - 1, upper_brightness)
	end
	grid_led(fader_index, middle_y, middle_brightness)
end

function render_fader_tune_position(fader_index, y_offset)
	-- fader position leds are 7 pads tall
	for i = 1, 7 do
		brightness = 0
		if i == 4 then brightness = 2 end
		grid_led(fader_index, i + y_offset, brightness)
	end

	-- Aliased position
	fader_position = round(linlin(fader_pos[fader_index], 0.0, 1.0, 7.0, 1.0), 1) + y_offset
	-- print("fader: " .. fader_index .. " position: " .. fader_position)
	grid_led(fader_index, fader_position, MAX_BRIGHTNESS)
end

function render_settings_page(y_offset)
	-- TODO: Write this
	for x=1, MAX_X do
		for y= y_offset, 8 + y_offset do
			grid_led(x, y, 1)
		end
	end
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
		render_settings_page(y_offset)
	elseif name == "slide" then
		for fader = 1, MAX_X do
			render_fader_slide_position(fader, y_offset)
		end
	elseif name == "tune" then
		for fader = 1, MAX_X do
			render_fader_tune_position(fader, y_offset)
		end
	end
end

function render_grid()
	-- grid_led_all(0)
	if GRID_VARIANT == "One" then
		render_fader_select_bar(MAX_Y)
		render_page(GRID_VERTICAL_OFFSET, single_page)
	elseif GRID_VARIANT == "Zero" then
		-- render_page(0, "tune")
		render_fader_select_bar(HALF_Y)
		render_fader_select_bar(HALF_Y + 1)
		render_page(GRID_VERTICAL_OFFSET + 1, "slide")
	end
	grid_refresh()
end

init()