--[[
	GD50 2018
	Pong Remake

	pong-0
	"The Day-0 Update"
]]

--[[
	Global Variables to set window resolution
	16:9 Aspect Ratio
]]

WINDOW_HEIGHT = 540
WINDOW_WIDTH = 960

--[[
	love.load always runs on startup
	Set window resolution
	Passing in a table with different values
	Not fullscreen, not resizable, synced to moniter refresh rate
]]

function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
	    fullscreen = false,
		resizable = false,
		vsync = true
	})
end

--[[
	love.draw is used to draw anything to screen
]]

function love.draw()
    love.graphics.printf(
		'Hello Pong!',
		0,
		WINDOW_HEIGHT / 2 - 6, -- Shift by 6 since LOVE2D default font size is 12
		WINDOW_WIDTH,
		'center')
end