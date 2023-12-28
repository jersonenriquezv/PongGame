local Player = require "Player"
local Enemy = require "Enemy"
local Ball = require "Ball"
local resetPositions = require "resetPositions"


local difficulties = {"Easy", "Medium", "Hard"}
local menuOptions = {"Easy", "Medium", "Hard"}
local currentMenuSelection = 1


local difficultySettings = {
    Easy = {
        ballSpeed = 500,
        enemySpeed = 250,
        enemyReactionDelay = 0.4
    },
    Medium = {
        ballSpeed = 500,
        enemySpeed = 350,
        enemyReactionDelay = 0.3
    },
    Hard = {
        ballSpeed = 600,
        enemySpeed = 450,
        enemyReactionDelay = 0.1
    }
}
currentScreen = 'menu'



function love.load()
    -- Initialize game objects
    player = Player.new()
    enemy = Enemy.new()
    ball = Ball.new()

    -- Initialize scores or other player/enemy 
    player.score = 0
    enemy.score = 0

    -- Load audio resources
    enemySound = love.audio.newSource("Audiofile/enemy.wav", "static")
    playerSound = love.audio.newSource("Audiofile/player.wav", "static")
    scoreSound = love.audio.newSource("Audiofile/score.wav", "static")

    -- Load fonts
    scoreFont = love.graphics.newFont(98)

    -- Set up initial game state or screen
    currentScreen = 'menu'  
     
    -- Set background color or other global settings
    love.graphics.setBackgroundColor(1, 1, 1)
    menuFont = love.graphics.newFont(100)
end

function checkWinner()
    if player.score >= 3 then 
        return "Enemy"
    elseif enemy.score >= 3 then 
        return "Player"
    end
    return nil

end
function love.update(dt)

    if currentScreen == 'playing' then
        print("game is playing")
        ball:Move(dt)
        player:Move(dt)
        enemy:Move(dt)
        target(ball, enemy)
        -- Collision player
        if checkCollision(ball,player) then
            ball.xVel = math.abs(ball.speed) -- Move ball to the right --

            local collisionPoint1 = (ball.y + ball.height / 2) - (player.y + player.height / 2)
            ball.yVel = collisionPoint1 * 7

            playerSound:play()
        end
        -- Collision enemy
        if checkCollision(ball, enemy) then
            ball.xVel = -math.abs(ball.speed) -- Move ball to the left --
            local collisionPoint2 = (ball.y + ball.height / 2) - (enemy.y + enemy.height / 2)
            ball.yVel = collisionPoint2 * 7
            enemySound:play()
        end

        -- score player
        if ball.x < 0 then
            player.score = player.score + 1
            resetPositions.resetPlayer(player)
            resetPositions.resetEnemy(enemy)
            resetPositions.resetBall(ball)

            scoreSound:play()
            
        -- score enemy
        elseif ball.x + ball.width > love.graphics.getWidth() then
            enemy.score = enemy.score + 1
            resetPositions.resetPlayer(player)
            resetPositions.resetEnemy(enemy)
            resetPositions.resetBall(ball)
            scoreSound:play()
           
        end
    elseif currentScreen == 'paused' then 
        -- do not update nothing
        end
    if checkWinner() then
        currentScreen = 'gameOver'
    end

end
function love.keypressed(key)
    -- Toggle between paused and playing when 'p' is pressed
    if (currentScreen == 'playing' or currentScreen == 'paused') and key == 'p' then
        if currentScreen == 'playing' then
            currentScreen = 'paused'

        else
            currentScreen = 'playing'
        end
    end
    if currentScreen == 'gameOver' then
        if key == ' ' then
            currentScreen = 'menu'
        end

        player.score = 0
        enemy.score = 0
        resetPositions.resetBall(ball)
        resetPositions.resetPlayer(player)
        resetPositions.resetEnemy(enemy)
        currentScreen = 'menu'
    end
    -- Handling menu interaction
    if currentScreen == 'menu' then
        if key == 'up' then
            currentMenuSelection = math.max(1, currentMenuSelection -1)
        elseif key == 'down' then
            currentMenuSelection = math.min(#menuOptions, currentMenuSelection + 1)
        elseif key == 'return' then
            currentDifficulty = menuOptions[currentMenuSelection]
            currentScreen = 'playing' 
    
        end
    end
end

function checkCollision(a, b)
    if a.x + a.width > b.x and a.x < b.x + b.width and a.y < b.y + b.height and a.y + a.height > b.y then
        return true
    else
        return false
    end
end

function target(ball, enemy)
    if ball.y + ball.height < enemy.y then
        enemy.yVel = -enemy.speed
    elseif ball.y > enemy.y + enemy.height then
        enemy.yVel = enemy.speed
    else
        enemy.yVel = 0
        enemy.reactionTimer = enemy.reactionDelays
    end
end

function love.draw()
    if currentScreen == 'menu' then
        love.graphics.clear()
        love.graphics.setBackgroundColor(0.5, 0.5, 0.5)
      

        -- Set the font for the menu
        local menuFontSize = 48
        local menuFont = love.graphics.newFont(menuFontSize)
        love.graphics.setFont(menuFont)

        local optionTextHeight = #menuOptions * (menuFontSize + 10)
        local startY = (love.graphics.getHeight() - optionTextHeight) / 2
        
        for i, option in ipairs(menuOptions) do
            -- If the current menu option is the selected one, highlight it
            if i == currentMenuSelection then
                love.graphics.setColor(1, 1, 1) -- Highlight color (white)
            else
                love.graphics.setColor(0.5, 0.5, 0.5) -- Normal color (gray)
            end

            -- Calculate the y-coordinate based on the option index
            local y = startY + (i - 1) * (menuFontSize + 10)  -- Adjust spacing
            
        

            -- Draw the option text centered
            love.graphics.print(option, (love.graphics.getWidth() - menuFont:getWidth(option)) / 2, y)
        end
    
    elseif currentScreen == 'playing' then
        love.graphics.clear(0.5, 0.5, 0.5)
    
        local windowWidth, windowHeight = love.graphics.getDimensions()
        -- creating a table in the middle 

        local tableWidth = windowWidth * 0.7
        local tableHeight = windowHeight * 0.7

        -- center the table
        local tableX = (windowWidth - tableWidth) / 2
        local tableY = (windowHeight - tableHeight) / 2
        
        love.graphics.setColor(1, 1, 1)
        love.graphics.setLineWidth(5)
        love.graphics.rectangle('line', tableX, tableY, tableWidth, tableHeight)
        love.graphics.setLineWidth(1)

        local dashLength = 10
        local spaceLength = 10
        local lineX = windowWidth / 2
        local startY = tableY
        while startY < tableY + tableHeight do
            love.graphics.line(lineX, startY, lineX, startY + dashLength)
            startY = startY + dashLength + spaceLength
        end

        love.graphics.setFont(scoreFont)
        love.graphics.setColor(1, 1, 1, 0.7)
        love.graphics.print(player.score, tableX * 5, 100)
        love.graphics.print(enemy.score, windowWidth - tableX * 5, 100)
        love.graphics.setColor(1, 1, 1, 1)

        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
        love.graphics.rectangle("fill", enemy.x, enemy.y, enemy.width, enemy.height)
        love.graphics.rectangle("fill", ball.x, ball.y, ball.width, ball.height)
    elseif currentScreen == 'paused' then
        love.graphics.printf("Paused", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), 'center')
    
    elseif currentScreen == 'gameOver' then
        local winner = checkWinner()
        love.graphics.printf(winner .. " Wins!", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), 'center')
    end
end