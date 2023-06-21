Door = Entity:extend()

function Door:new(x, y)
  Door.super.new(self, x, y, "lockedGate.png")
  local width = self.image:getWidth()
  local height = self.image:getHeight()
  
  self.frames = {}
  self.maxFrames = 8
  self.hitbox = love.graphics.rectangle("line", self.x, self.y, 50, 150)
  self.spinRate= 7
  self.type = "Door"
  self.open = false
  
  local frame_width = 50
  local frame_height = 150
  
  for i=0,7 do
    table.insert(self.frames,love.graphics.newQuad(1 + i * (frame_width + 1), 1, frame_width, frame_height, width, height))
    if #self.frames == self.maxframes then
      break
    end
  end  

  self.currentFrame = 1
end

