local Player = class({
    name = "player"
})

local sprite = require("sprite")

function Player:new()
    self.position = vec2(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    self.friction = 0.9
    self.speed = 200
    self.radius = 16

    self.score = 0

    self.hit = false
    self.lines = {}
    self.circles = {}

    table.insert(self.circles, {
        position = self.position,
        sprite = sprite:getRandomSprite()
    })
end

function Player:draw()
    if self.hit then
        love.graphics.setColor(1, 0, 0)
    else
        love.graphics.setColor(1, 1, 1)
    end

    for _, circle in ipairs(self.circles) do
        love.graphics.circle("line", circle.position.x, circle.position.y, self.radius)

        love.graphics.draw(sprite.sprite, circle.sprite, circle.position.x - self.radius, circle.position.y - self.radius)
    end

    for _, line in ipairs(self.lines) do
        love.graphics.line(line.position.x, line.position.y, line.endPosition.x, line.endPosition.y)
    end
end

function Player:update(dt)
    local velocity = vec2(0, 0)

    if love.keyboard.isDown("left") then
        velocity.x = velocity.x - self.speed * dt
    elseif love.keyboard.isDown("right") then
        velocity.x = velocity.x + self.speed * dt
    end

    if love.keyboard.isDown("up") then
        velocity.y = velocity.y - self.speed * dt
    elseif love.keyboard.isDown("down") then
        velocity.y = velocity.y + self.speed * dt
    end

    for _, v in ipairs(self.circles) do
        v.position:vector_add_inplace(velocity)
    end
end

function Player:addEnemy(enemy)
    table.insert(self.lines, { position = enemy.position, endPosition = enemy.endPosition })
    table.insert(self.circles, { position = enemy.position, sprite = enemy.startSprite })
    table.insert(self.circles, { position = enemy.endPosition, sprite = enemy.endSprite})
end

return Player
