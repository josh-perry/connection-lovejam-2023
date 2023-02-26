local Enemy = class({
    name = "enemy"
})

local sprite = require("sprite")

function Enemy:new(length, spinSpeed)
    self.length = 0
    self.maxLength = length
    self.angle = 0
    self.radius = 16

    self.spinSpeed = spinSpeed

    local center = {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2
    }

    local distance = math.max(center.x, center.y)
    local angle = math.random() * 2 * math.pi
    local dx = distance * math.cos(angle)
    local dy = distance * math.sin(angle)

    self.position = vec2(center.x + dx, center.y + dy)
    self.endPosition = self.position

    self.destination = vec2(love.math.random(0, love.graphics.getWidth(), love.math.random(0, love.graphics.getHeight())))

    self.startSprite = sprite:getRandomSprite()
    self.endSprite = sprite:getRandomSprite()

    self.hasSkull = love.math.random() < 0.3

    if self.hasSkull then
        self.endSprite = sprite:getSkull()
    end
end

function Enemy:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.line(self.position.x, self.position.y, self.endPosition.x, self.endPosition.y)
    love.graphics.circle("fill", self.position.x, self.position.y, self.radius)
    love.graphics.circle("fill", self.endPosition.x, self.endPosition.y, self.radius)

    love.graphics.draw(sprite.sprite, self.startSprite, self.position.x - self.radius, self.position.y - self.radius)
    love.graphics.draw(sprite.sprite, self.endSprite, self.endPosition.x - self.radius, self.endPosition.y - self.radius)
end

function Enemy:update(dt, difficulty)
    local vel = vec2(self.destination)
        :vector_sub_inplace(self.position)
        :normalize_both_inplace()
        :scalar_mul_inplace(difficulty)

    self.position:vector_add_inplace(vel)

    self.length = math.min(self.length + (dt * self.spinSpeed * 50), self.maxLength)

    self.angle = self.angle + self.spinSpeed * dt

    local endX = self.position.x + self.length * math.cos(self.angle)
    local endY = self.position.y + self.length * math.sin(self.angle)

    self.endPosition = vec2(endX, endY)
end

return Enemy
