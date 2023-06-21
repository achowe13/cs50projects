Coin = Entity:extend()

function Coin:new(x, y)
  Coin.super.new(self, x, y, "spinningCoin.png")
  local width = self.image:getWidth()
  local height = self.image:getHeight()
  
  self.frames = {}
  self.maxFrames = 8
  self.spinRate = 10
  self.type = "coin"
  
  self.frameWidth = 25
  self.frameHeight = 25
  
  for i=0,7 do
    table.insert(self.frames,love.graphics.newQuad(1 + i * (self.frameWidth + 1), 1, self.frameWidth, self.frameHeight, width, height))
    if #self.frames == self.maxframes then
      break
    end
  end  

  self.currentFrame = 1
end

function Coin:drawHitbox(x, y)
  love.graphics.setColor(255, 255 ,255, 0)
  love.graphics.rectangle("line", x, y, 25, 25)
  love.graphics.setColor(255, 255 ,255, 255)
end