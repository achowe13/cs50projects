Box = Entity:extend()

function Box:new(x, y)
  Box.super.new(self, x, y, "box1.png")
end