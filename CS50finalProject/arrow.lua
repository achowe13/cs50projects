Arrow = Entity:extend()

function Arrow:new(x, y, direction)
  if direction == "right" then
    Arrow.super.new(self, x + 20, y + 30, "arrow1.png")
  elseif direction == "left" then
    Arrow.super.new(self, x - 20, y + 30, "arrow2.png")
  end
  self.direction = direction
end

function Arrow:update(dt, direction)
  if self.direction == "right" then
    self.x = self.x + 800 * dt
  elseif self.direction == "left" then
    self.x = self.x - 800 * dt
  end
end
