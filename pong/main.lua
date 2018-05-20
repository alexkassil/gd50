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
	class library
	https://github.com/vrld/hump/blob/master/class.lua
--]]
Class = require 'class'

-- our Paddle class
require 'Paddle'

-- our Ball class
require 'Ball'

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

	-- startup our RNG seeded with the time
	math.randomseed(os.time())

	-- set title
	love.window.setTitle('PONG')

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

	-- create 2 paddles for each player
	player1 = Paddle(10, 30, 5, 20)
	player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

	-- place ball in middle of screen
	ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

	gameState = 'start'
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
		player1.dy = -PADDLE_SPEED
		player1:update(dt)
	elseif love.keyboard.isDown('s') then
		player1.dy = PADDLE_SPEED
		player1:update(dt)
	end

	-- player 2 movement
	if love.keyboard.isDown('up') then
		player2.dy = -PADDLE_SPEED
		player2:update(dt)
	elseif love.keyboard.isDown('down') then
		player2.dy = PADDLE_SPEED
		player2:update(dt)
	end

	-- ball movement only if in play state
	if gameState == 'play' then
		if ball:collides(player1) then
			ball.dx = -ball.dx * 1.03
			-- remove ball from collision box
			ball.x = player1.x + 5

			ball.dy = (ball.dy / math.abs(ball.dy)) * math.random(10, 150)
		end

		if ball:collides(player2) then
			ball.dx = -ball.dx * 1.03
			-- remove ball from collision box
			ball.x = player2.x - 4

			ball.dy = ball.dy / math.abs(ball.dy) * math.random(10, 150)
		end
		ball:update(dt)
	end
end

--[[
	Keyboard handling, called by LOVE2D each frame
]]

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	-- reset the game or start the game
	elseif key == 'enter' or key == 'return' then
		if gameState == 'start' then
			gameState = 'play'
		else
			gameState = 'start'

			ball:reset()
		end
	end
end

--[[
	love.draw is used to draw anything to screen
]]

function love.draw()
	push:apply('start')

	love.graphics.clear(40, 45, 52, 255)

	-- welcome text
	love.graphics.setFont(smallFont)

	if gameState == 'start' then
		love.graphics.printf('Hello Start State!', 0, 20, VIRTUAL_WIDTH, 'center')
	else
		love.graphics.printf('Hello Play State!', 0, 20, VIRTUAL_WIDTH, 'center')
	end

	-- score
	love.graphics.setFont(scoreFont)
	love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
	love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

	player1:render()
	player2:render()

	ball:render()

	displayFPS()

	-- end rendering at virtual resolution
	push:apply('end')
end

--[[
	Render the current FPS
--]]
function displayFPS()
	-- simple FPS display across all states
	love.graphics.setFont(smallFont)
	love.graphics.setColor(0, 255, 0, 255)
	love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end
