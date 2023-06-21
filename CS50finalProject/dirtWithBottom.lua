DirtWithBottom = Entity:extend()

function DirtWithBottom:new(x, y)
  DirtWithBottom.super.new(self, x, y, "bottomdirt.png", 1)
  
  self.strength = 100
  self.weight = 0
end
