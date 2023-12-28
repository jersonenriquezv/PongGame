local Ball = {}
Ball.__index = Ball

function Ball.new()
    local self = setmetatable({}, Ball)
    self.width = 20
    self.height = 20
    self.speed = 900
    self.xVel = self.speed
    self.yVel = 0
    self.x = (love.graphics.getWidth() / 2) - (self.width / 2)
    self.y = (love.graphics.getHeight() / 2) - (self.height / 2)
    return self

end

function Ball:Move(dt)
    self.x = self.x + self.xVel * dt
    self.y = self.y + self.yVel * dt
    -- Bounce off top and bottom of the screen --
    if self.y < 0 then
        self.y = 0
        self.yVel = -self.yVel
    elseif self.y + self.height > love.graphics.getHeight() then
        self.y = love.graphics.getHeight() - self.height
        self.yVel = -self.yVel
    end

end
return Ball
