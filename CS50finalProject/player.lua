Player = Entity:extend()

function Player:new(x, y)
    Player.super.new(self, x, y, "2dArcher/idle/idleArcher1.png")
    
    self.idleframes = {}
    for i=1,4 do
      table.insert(self.idleframes, love.graphics.newImage("2dArcher/idle/idleArcher" .. i .. ".png"))
    end
    
    self.shootframes = {}
    for i=1,7 do
      table.insert(self.shootframes, love.graphics.newImage("2dArcher/shoot/shoot" .. i .. ".png"))
    end
    
    self.runframes = {}
    for i=1,7 do
      table.insert(self.runframes, love.graphics.newImage("2dArcher/run/run" .. i .. ".png"))
    end
    
    self.jumpframes = {}
    for i=1,7 do
      table.insert(self.jumpframes, love.graphics.newImage("2dArcher/jump/jump" .. i .. ".png"))
    end
    
    self.strength = 10
    self.direction = "right"
    self.haskey = false
    self.currentFrame = 1
    self.animation = self.idleframes
    self.sx = 1
end

function Player:update(dt)
  
  Player.super.update(self, dt)
  local speed = 200
  if love.keyboard.isDown("l") then
    speed = speed + 200
  end
  
  
  
  
  
  if love.keyboard.isDown("d") then
    self.x = self.x + speed * dt
    self.direction = "right"
    self.animation = self.runframes
    self.sx = 1
  elseif love.keyboard.isDown("a") then
    self.x = self.x - speed * dt
    self.direction = "left"
    self.animation = self.runframes
    self.sx = -1
  else
    self.animation = self.idleframes
  end
  
  if self.last.y ~= self.y then
    self.canJump = false
  end
  
  if self.animation == self.idleframes then
    self.currentFrame = self.currentFrame + 4 * dt
    if self.currentFrame >= 4 then
      self.currentFrame = 1
    end
  else
    self.currentFrame = self.currentFrame + 10 * dt
    if self.currentFrame >= 7 then
      self.currentFrame = 1
    end
  end
end

function Player:jump()
  if self.canJump then
    self.gravity = -550
    --counter for double jump added here?
    self.canJump = false
  end
end

function Player:collide(e, direction)
  Player.super.collide(self, e, direction)
  if direction == "bottom" then    
    self.canJump = true
  end
end

function Player:checkResolve(e, direction)
  if e:is(Spike) then
    love.event.quit("restart")
  else
    return true
  end
end
    

