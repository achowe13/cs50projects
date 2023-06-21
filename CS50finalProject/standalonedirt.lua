StandAloneDirt = Entity:extend()

function StandAloneDirt:new(x, y)
  StandAloneDirt.super.new(self, x, y, "metalblock2.png", 1)
  
  self.strength = 100
  self.weight = 0
end
