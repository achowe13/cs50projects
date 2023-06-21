Enemy = Object:extend()

function Enemy:new()
    self.image = love.graphics.newImage("ed.png")
    self.x = 325
    self.y = 450
    self.speed = 100
    self.width = 200
    self.height = 200
end

function Enemy:update(dt)
  self.x = self.x + self.speed * dt
  
  local window_width = love.graphics.getWidth()
  
  if self.x < 0 then
    self.x = 0
    self.speed = -self.speed
    
  elseif self.x + self.width > window_width then
    self.x = window_width - self.width
    self.speed = -self.speed
  end
end

function Enemy:draw()
  love.graphics.draw(self.image, self.x, self.y, 0, self.width/64, self.width/64)
end
