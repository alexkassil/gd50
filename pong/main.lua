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

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

--[[
	love.load always runs on startup
	Set window resolution
	Passing in a table with different values
	Not fullscreen, not resizable, synced to moniter refresh rate
]]

function love.load()
	-- use nearest-neighbor filtering to prevent blurring of text
	love.graphics.setDefaultFilter('nearest', 'nearest')
	
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
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
	push:apply('start')
	
    love.graphics.printf(
		'Hello Pong!',
		0,
		VIRTUAL_HEIGHT / 2 - 6, -- Shift by 6 since LOVE2D default font size is 12
		VIRTUAL_WIDTH,
		'center')

	-- end rendering at virtual resolution
	push:apply('end')
end

