local Sprite = class({
    name = "sprite"
})

function Sprite:new()
    self.sprite = love.graphics.newImage("assets/img/faces.png")
    self.faceSize = 32
end

function Sprite:getRandomSprite()
    local facesX = self.sprite:getWidth() / self.faceSize

    local index = love.math.random(1, facesX - 1)
    return love.graphics.newQuad(index * self.faceSize, 0, self.faceSize, self.faceSize, self.sprite:getWidth(), self.sprite:getHeight())
end

function Sprite:getSkull()
    return love.graphics.newQuad(0, 0, self.faceSize, self.faceSize, self.sprite:getWidth(), self.sprite:getHeight())
end

return Sprite()
