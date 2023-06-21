Grass3 = Entity:extend()

function Grass3:new(x, y)
  Grass3.super.new(self, x, y, "grass3.png", 1)
  
  self.strength = 100
  self.weight = 0
end
