Grass2 = Entity:extend()

function Grass2:new(x, y)
  Grass2.super.new(self, x, y, "grass2.png", 1)
  
  self.strength = 100
  self.weight = 0
end
