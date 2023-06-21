Spike = Entity:extend()

function Spike:new(x, y)
  Spike.super.new(self, x, y, "spikes1.png")
  
  self.strength = 100
  self.weight = 0
end