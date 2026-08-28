local MAX_X=grid_size_x()
local MAX_Y=grid_size_y()
local GRID_VARIANT=(MAX_Y==16 and MAX_X==16) and "Zero" or (MAX_Y==8 and MAX_X==16) and "One"
local GRID_VERTICAL_OFFSET=(GRID_VARIANT=="Zero") and 8 or 0
local MAX_BRIGHTNESS = 15
local NUM_ACCESS_BUTTONS = 4
local menu_access_buttons_held=0
local last_menu_button_press_time=nil
local single_layer="settings"
local selected_fader=1
local fader_pos = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

function init()
	render_grid()
end

function toggle_layer()
	if single_layer == "faders" then
		single_layer="settings"
	else
		single_layer="faders"
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

function grid(x,y,z)
	if GRID_VARIANT == "One" then
		if x>=13 and x<=MAX_X and y==MAX_Y then
			handle_menu_access_button_press(z)
		end

		if menu_access_buttons_held==NUM_ACCESS_BUTTONS then
			if z==1 then
				toggle_layer()
			end
		end
	end

	if y == MAX_Y then
		selected_fader=x
	end
	render_grid()
end

function render_layer(y_offset, layer)
	if layer == "settings" then
		for x=1, MAX_X do
			local brightness = 0
			if x == selected_fader then
				brightness = MAX_BRIGHTNESS
			end
			grid_led(x,8+y_offset,brightness)
		end
	elseif layer == "faders" then
		grid_led_all(0)
	end
end
function render_grid()
	if GRID_VARIANT == "One" then
		render_layer(GRID_VERTICAL_OFFSET, single_layer)
	elseif GRID_VARIANT == "Zero" then
		render_layer(GRID_VERTICAL_OFFSET, "settings")
		render_layer(0, "faders")
	end
	grid_refresh()
end

init()