Bob = Entity:extend()

function Bob:new(x, y)
    Bob.super.new(self, x, y, "bob.png")
    self.xorigin = x
    self.strength = 1
    self.speed = 200
end

function Bob:update(dt)
  self.x = self.x + self.speed * dt
  
  if self.x < self.xorigin - 150 then
    self.x = self.xorigin - 150
    self.speed = -self.speed
  elseif self.x > self.xorigin + 150 then
    self.x = self.xorigin + 150
    self.speed = -self.speed
  end
end