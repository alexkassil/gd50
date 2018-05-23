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
	largeFont = love.graphics.newFont('font.ttf', 16)
	scoreFont = love.graphics.newFont('font.ttf', 32)

	love.graphics.setFont(smallFont)

	sounds = {
		['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', static),
		['score'] = love.audio.newSource('sounds/score.wav', static),
		['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', static)
	}

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

	player1Score = 0
	player2Score = 0

	servingPlayer = 1

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
	if gameState == 'serve' then
		-- initialize velocity based on serving player
		ball.dy = math.random(-50, 50)
		if servingPlayer == 1 then
	   		ball.dx = math.random(140, 200)
		else
			ball.dx = -math.random(140, 200)
		end
	-- ball movement only if in play state
	elseif gameState == 'play' then
		if ball:collides(player1) then
			ball.dx = -ball.dx * 1.03
			-- remove ball from collision box
			ball.x = player1.x + 5
			sounds['paddle_hit']:play()

			if ball.dy < 0 then
				ball.dy = -math.random(10, 150)
			else
				ball.dy = math.random(10, 150)
			end
		end

		if ball:collides(player2) then
			ball.dx = -ball.dx * 1.03
			-- remove ball from collision box
			ball.x = player2.x - 4
			sounds['paddle_hit']:play()

			if ball.dy < 0 then
				ball.dy = -math.random(10, 150)
			else
				ball.dy = math.random(10, 150)
			end
		end
		-- if we reach left or right edge of screen
		-- we increment score and reset ball
		if ball.x < 0 then
			sounds['score']:play()
			servingPlayer = 1
			player2Score = player2Score + 1

			if player2Score == 5 then
				winningPlayer = 2
				gameState = 'done'
			else
				gameState = 'serve'
				ball:reset()
			end
		end

		if ball.x > VIRTUAL_WIDTH then
			sounds['score']:play()
			servingPlayer = 2
			player1Score = player1Score + 1
			if player1Score == 5 then
				winningPlayer = 1
				gameState = 'done'
			else
				gameState = 'serve'
				ball:reset()
			end
		end
	end

	-- player 1 movement
	if love.keyboard.isDown('w') then
		player1.dy = -PADDLE_SPEED
	elseif love.keyboard.isDown('s') then
		player1.dy = PADDLE_SPEED
	else
		player1.dy = 0
	end

	-- player 2 movement
	if love.keyboard.isDown('up') then
		player2.dy = -PADDLE_SPEED
	elseif love.keyboard.isDown('down') then
		player2.dy = PADDLE_SPEED
	else
		player2.dy = 0
	end

	player1:update(dt)
	player2:update(dt)

	if gameState == 'play' then
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
			gameState = 'serve'
		elseif gameState == 'serve' then
			gameState = 'play'
		elseif gameState == 'done' then
			gameState = 'serve'

			ball:reset()

			player1Score = 0
			player2Score = 0

			if winningPlayer == 1 then
				servingPlayer = 2
			else
				servingPlayer = 1
			end
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
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
	    love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        -- no UI messages to display in play
    elseif gameState == 'done' then
		love.graphics.setFont(largeFont)
		love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!', 0, 10, VIRTUAL_WIDTH, 'center')
		love.graphics.setFont(smallFont)
		love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
	end

	displayScore()

	player1:render()
	player2:render()

	ball:render()

	displayFPS()

	-- end rendering at virtual resolution
	push:apply('end')
end

--[[
	Keep aspect ratio when resizing
--]]
function love.resize(w, h)
	push.resize(w, h)
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

--[[
	Display the score
--]]
function displayScore()
	-- score
	love.graphics.setFont(scoreFont)
	love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
	love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
end