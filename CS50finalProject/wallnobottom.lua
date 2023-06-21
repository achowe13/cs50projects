WallNoBottom = Entity:extend()

function WallNoBottom:new(x, y)
  WallNoBottom.super.new(self, x, y, "jumpthroughblock.png")
  self.strength = 100
  self.weight = 0
end