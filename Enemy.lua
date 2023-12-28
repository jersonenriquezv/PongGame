local Enemy = {}
Enemy.__index = Enemy

function Enemy.new()
    local self = setmetatable({}, Enemy)
    self.width = 20
    self.height = 100
    self.speed = 400
    self.yVel = 0
    self.x = love.graphics.getWidth() - self.width - 50
    self.y = love.graphics.getHeight() / 2
    self.reactionDelay = 0.02
    self.reactionTimer = self.reactionDelay

    return self
end

function Enemy:Move(dt)
    self.reactionTimer = 0

    if self.y < 0 then
        self.y = 0
    -- Ensure self.y never goes beyond the bottom of the screen
    elseif self.y + self.height > love.graphics.getHeight() then
        self.y = love.graphics.getHeight() - self.height
    end
    -- Decrease the reaction timer
    if self.reactionTimer > 0 then
        self.reactionTimer = self.reactionTimer - dt
    end
    -- Move the enemy after the reaction timer runs out
    if self.reactionTimer <= 0 then
        self.y = self.y + self.yVel * dt
    end
end

return Enemy
