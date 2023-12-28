local Player = require "Player"
local Enemy = require "Enemy"
local Ball = require "Ball"
local resetPositions = {} 
function resetPositions.resetPlayer(Player)
    player.x = 50
    player.y = love.graphics.getHeight() / 2 - player.height / 2
end

function resetPositions.resetEnemy(Enemy)
    enemy.x = love.graphics.getWidth() - enemy.width - 50
    enemy.y = love.graphics.getHeight() / 2 - enemy.height / 2
end

function resetPositions.resetBall(Ball)
    -- Reset the ball to the center of the screen
    ball.x = love.graphics.getWidth() / 2 - ball.width / 2
    ball.y = love.graphics.getHeight() / 2 - ball.height / 2

    ball.yVel = 0
    if ball.x < 0 then
        ball.xVel = ball.speed
    else
        ball.xVel = -ball.speed
    end
end
return resetPositions 