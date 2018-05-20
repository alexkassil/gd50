Ball = Class{}

function Ball:init(x, y, w, h)
	self.x = x
	self.y = y
	self.w = w
	self.h = h

	self.dy = math.random(2) == 1 and -100 or 100
	self.dx = math.random(-50, 50)
end

function Ball:reset()
	self.x = VIRTUAL_WIDTH / 2 - 2
	self.y = VIRTUAL_HEIGHT / 2 - 2
	
	self.dy = math.random(2) == 1 and -100 or 100
	self.dx = math.random(-50, 50)
end

function Ball:update(dt)
	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt

	-- ball collisions
	if self.y < 0 then
		self.y = 0
		self.dy = -self.dy
	elseif self.y > VIRTUAL_HEIGHT then
		self.y = VIRTUAL_HEIGHT
		self.dy = -self.dy
	end
end

function Ball:render()
	love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
end