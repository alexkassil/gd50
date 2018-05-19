--[[
	GD50 2018
	Pong Remake

	Following lesson given here:
	cs50.github.io/games
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

-- speed at which we move the paddle
PADDLE_SPEED = 200

--[[
	love.load always runs on startup
	Set window resolution
	Passing in a table with different values
	Not fullscreen, not resizable, synced to moniter refresh rate
]]

function love.load()
	-- use nearest-neighbor filtering to prevent blurring of text
	love.graphics.setDefaultFilter('nearest', 'nearest')

	-- more retro font object
	smallFont = love.graphics.newFont('font.ttf', 8)

	scoreFont = love.graphics.newFont('font.ttf', 32)

	love.graphics.setFont(smallFont)
	
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

	player1Score = 0
	player2Score = 0

	player1Y = 30
	player2Y = VIRTUAL_HEIGHT - 50
end

--[[
	Runs every fram, with "dt" being our change in seconds
	since last frame, given by LOVE2D
	We scale our speed by delta time to have consistend movement
	regardless of FPS
--]]

function love.update(dt)
	-- player 1 movement
	if love.keyboard.isDown('w') then
		-- add negative paddle speed to current Y scaled by deltaTime
		player1Y = player1Y - PADDLE_SPEED * dt
	elseif love.keyboard.isDown('s') then
		-- add positive paddle speed to current Y scaled by deltaTime
		player1Y = player1Y + PADDLE_SPEED * dt
	end

	-- player 2 movement
	if love.keyboard.isDown('up') then
		-- add negative paddle speed to current Y scaled by deltaTime
		player2Y = player2Y - PADDLE_SPEED * dt
	elseif love.keyboard.isDown('down') then
		-- add positive paddle speed to current Y scaled by deltaTime
		player2Y = player2Y + PADDLE_SPEED * dt
	end
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

	-- clear the screen with a specific color
	love.graphics.clear(40, 45, 52, 255)

	-- welcome text
    love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')

	-- render left paddle
	love.graphics.rectangle('fill', 10, player1Y, 5, 20)

	-- render right paddle
	love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)

	-- render ball
	love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

	-- end rendering at virtual resolution
	push:apply('end')
end

