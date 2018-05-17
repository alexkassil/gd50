--[[
	GD50 2018
	Pong Remake

	pong-0
	"The Day-0 Update"
]]

--[[
	Get a library
	push will turn our resolution retro
	https://github.com/Ulydev/push
]]
push = require 'push'

--[[
	Global Variables to set window resolution
	16:9 Aspect Ratio
]]

WINDOW_HEIGHT = 540
WINDOW_WIDTH = 960

VIRTUAL_WIDTH = 324
VIRTUAL_HEIGHT = 182

--[[
	love.load always runs on startup
	Set window resolution
	Passing in a table with different values
	Not fullscreen, not resizable, synced to moniter refresh rate
]]

function love.load()
	-- use nearest-neighbor filtering to prevent blurring of text
	love.graphics.setDefaulFilter('nearest', 'nearest')
	
    push:setupScreen(VITRUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
	    fullscreen = false,
		resizable = false,
		vsync = true
	})
end

--[[
	Keyboard handling, called by LOVE2D each frame
]]

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
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