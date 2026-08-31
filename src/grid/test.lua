local DIM_BRIGHTNESS = 2
local MAX_BRIGHTNESS = 15

grid_led_all(DIM_BRIGHTNESS)
grid_refresh()

function event_grid(x, y, z)
	print("x: " .. x .. " y: " .. y .. " z: " .. z)
	if z == 1 then
		brightness = MAX_BRIGHTNESS
	else
		brightness = DIM_BRIGHTNESS
	end
	grid_led(x, y, brightness)
	grid_refresh()
end
