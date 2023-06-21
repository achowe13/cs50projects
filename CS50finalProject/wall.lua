Wall = Entity:extend()

function Wall:new(x, y)
  Wall.super.new(self, x, y, "grass2.png", 1)
  
  self.strength = 100
  self.weight = 0
end
