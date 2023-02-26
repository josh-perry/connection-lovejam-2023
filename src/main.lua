require("lib.batteries"):export()

local Player = require("player")
local Enemy = require("enemy")

local sprite = require("sprite")

local player
local enemies

local maxEnemySpawnTimer = 3
local enemySpawnTimer = maxEnemySpawnTimer

local sfx = {
    collected = love.audio.newSource("assets/sfx/Hive-bounce-4.wav", "static"),
    hit = love.audio.newSource("assets/sfx/Noise hit b1-bounce-1.wav", "static")
}

local music = love.audio.newSource("assets/music/main_theme_2023-02-26_2043.ogg", "stream")

local bigFont = love.graphics.newFont("assets/fonts/ComicNeue-Bold.ttf", 72)
local smallFont = love.graphics.newFont("assets/fonts/ComicNeue-Bold.ttf", 32)

local flux = require("lib.flux")

local scoreNotifications

local difficulty

function reset()
    player = Player()
    difficulty = 1

    enemies = {}
    scoreNotifications = {}
end

function love.load()
    music:setVolume(0.4)
    music:setLooping(true)
    music:play()

    reset()
end

function love.draw()
    love.graphics.clear(0.38, 0.56, 0.9)
    love.graphics.setFont(bigFont)
    love.graphics.printf(player.score, 0, 200, love.graphics.getWidth(), "center")

    if player.hit then
        love.graphics.printf("you lost lol", 0, 20, love.graphics.getWidth(), "center")
        return
    end

    player:draw()

    for _, v in ipairs(enemies) do
        v:draw()
    end

    for _, n in ipairs(scoreNotifications) do
        love.graphics.setColor(1, 1, 1, n.alpha)
        love.graphics.circle("fill", n.x, n.y, (1 - n.alpha) * 200)
    end

    love.graphics.setFont(smallFont)
    for _, n in ipairs(scoreNotifications) do
        love.graphics.setColor(1, 1, 1, n.alpha)
        love.graphics.print(n.amount, n.x, n.y)
    end

    love.graphics.setColor(1, 1, 1, 1)
end

function love.update(dt)
    if player.hit then
        return
    end

    difficulty = difficulty + (dt / 10)

    enemySpawnTimer = enemySpawnTimer - dt

    if enemySpawnTimer <= 0 then
        enemySpawnTimer = maxEnemySpawnTimer

        local length = love.math.random(50, 150) * difficulty
        local spinSpeed = love.math.random(1, difficulty)
        table.insert(enemies, Enemy(length, spinSpeed))
    end

    player:update(dt)

    for _, v in ipairs(enemies) do
        v:update(dt, difficulty)

        local touchingAnyBalls = false

        for _, circle in ipairs(player.circles) do
            local touchedStart = intersect.circle_circle_collide(circle.position, player.radius, v.position, v.radius)
            local touchedEnd = intersect.circle_circle_collide(circle.position, player.radius, v.endPosition, v.radius)

            if touchedEnd and v.hasSkull then
                player.hit = true
                sfx.hit:play()
                return
            end

            if touchedStart or touchedEnd then
                touchingAnyBalls = true

                if v.hasSkull then
                    v.endSprite = sprite:getRandomSprite()
                end

                player:addEnemy(v)
                sfx.collected:play()
                local score = 100

                local notification = {
                    x = v.position.x,
                    y = v.position.y,
                    alpha = 1,
                    amount = score
                }

                flux.to(notification, 2, {
                    y = v.position.y - 100,
                    alpha = 0
                }):ease("cubicout"):oncomplete(function()
                    player.score = player.score + score
                end)

                table.insert(scoreNotifications, notification)

                v.dead = true
                break
            end
        end

        if not v.dead then
            for _, circle in ipairs(player.circles) do
                if not touchingAnyBalls and intersect.line_circle_collide(v.position, v.endPosition, 1, circle.position, player.radius) then
                    player.hit = true
                    sfx.hit:play()
                    break
                end
            end
        end
    end

    for i = #enemies, 1, -1 do
        local enemy = enemies[i]

        if enemy.dead then
            table.remove(enemies, i)
        end
    end

    flux.update(dt)
end

function love.keypressed(key)
    if key == "space" and player.hit then
        reset()
    end
end
