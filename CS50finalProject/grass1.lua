Grass1 = Entity:extend()

function Grass1:new(x, y)
  Grass1.super.new(self, x, y, "grass4.png", 1)
  
  self.strength = 100
  self.weight = 0
end
