Dirt = Entity:extend()

function Dirt:new(x, y)
  Dirt.super.new(self, x, y, "dirt.png", 1)
  
  self.strength = 100
  self.weight = 0
end
