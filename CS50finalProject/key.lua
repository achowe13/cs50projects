Key = Entity:extend()

function Key:new(x, y)
  Key.super.new(self, x, y, "spinningkey.png")
  local width = self.image:getWidth()
  local height = self.image:getHeight()
  
  self.frames = {}
  self.maxFrames = 8
  self.hitbox = love.graphics.rectangle("line", self.x, self.y, 25, 25)
  self.spinRate= 7
  self.type = "key"
  
  self.frameWidth = 20
  self.frameHeight = 40
  
  for i=0,7 do
    table.insert(self.frames,love.graphics.newQuad(1 + i * (self.frameWidth + 1), 1, self.frameWidth, self.frameHeight, width, height))
    if #self.frames == self.maxframes then
      break
    end
  end  

  self.currentFrame = 1
end

--function Key:draw()
  --love.graphics.draw(self.image, self.frames[math.floor(self.currentFrame)], self.x, self.y)
--end
