function love.load()
  Object = require "classic"
  require "entity"
  require "player"
  require "grass1"
  require "grass2"
  require "grass3"
  require "dirt"
  require "spike"
  require "wallnobottom"
  require "box"
  require "arrow"
  require "bob"
  require "heart"
  require "dirtWithBottom"
  require "standalonedirt"
  require "key"
  require "coin"
  require "door"
  require "duck"
  --local maid64 = require "maid64"
  
  love.window.setMode(1920, 1080, {resizable=true, borderless=false})
  
  background = love.graphics.newImage("backround.png")
  
  song = love.audio.newSource("darkeningByDSTecnician.mp3", "stream")
  song:setLooping(true)
  song:play()
  
  --maid64.setup()

  player = Player(1600, 100)
  door = Door(1800,50)
  box = Box(550, 450)
  bob1 = Bob(750, 600)
  bob2 = Bob(700, 900)
  key = Key(65, 950)
  duck = Duck(1900, 100)
  
  -- HUDkey and HUDcoin are images for the HUD
  HUDkey = love.graphics.newImage("statickey.png")
  HUDcoin = love.graphics.newImage("staticcoin.png")
  
  -- player key and coin counters
  keys = 0
  coins = 0
  -- lists of enemies hearts arrows objects and collectables being initialized
  enemies = {}
  hearts = {}
  listOfArrows = {}
  objects = {}
  collectables = {}
  doors = {}
  
  -- start the player with 3 hearts
  for i=1,3 do
    table.insert(hearts, Heart(i * 50, 50))
  end
  
  --insert objects into respective tables
  
  table.insert(objects, box)
  table.insert(enemies, bob1)
  table.insert(enemies, bob2)  
  table.insert(collectables, key)
  table.insert(doors, door)
  
  -- initialize walls table
  walls = {}
  
  map = {
    {8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8},
    {0,0,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5},
    {0,0,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,9,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5},
    {0,0,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5},
    {1,1,1,1,1,5,0,0,0,0,0,0,0,0,0,0,0,0,3,1,2,3,1,2,1,2,1,2,2,3,1,2,1,2,1,2,2,1,1,3,2,1},
    {7,7,7,7,7,5,0,0,0,0,0,0,0,0,0,0,0,0,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,5},
    {0,0,0,0,0,5,0,0,0,0,9,9,9,0,0,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,5},
    {0,0,0,0,0,5,0,0,0,0,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5},
    {0,0,0,0,0,5,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,5},
    {0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,4,0,0,7,5},
    {0,0,0,0,0,5,3,0,0,0,4,4,4,0,0,0,0,0,0,0,5,0,0,4,4,4,0,0,0,4,0,0,4,0,0,0,0,0,0,0,0,5},
    {1,0,0,0,0,5,5,1,0,0,0,0,0,0,0,0,0,0,0,0,5,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,3,0,0,0,5},
    {5,0,0,0,0,5,5,5,2,0,0,0,0,0,0,0,0,0,0,0,5,1,3,3,2,1,1,2,1,3,1,1,2,2,2,2,2,5,0,0,0,5},
    {5,0,0,0,0,5,5,5,5,2,1,1,2,1,2,1,3,1,2,1,5,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,4,4,0,5},
    {5,0,0,0,0,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5},
    {5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5},
    {5,0,0,0,0,0,0,0,9,9,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,9,0,0,0,0,0,0,0,0,4,5},
    {5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5},
    {5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5},
    {5,0,0,0,0,0,0,2,0,0,0,1,2,2,1,3,2,1,0,0,0,0,0,3,0,0,0,4,4,0,0,0,0,4,4,0,0,0,0,4,4,5},
    {5,3,0,0,0,0,0,5,6,6,6,5,5,5,5,5,5,5,0,0,0,0,1,5,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,5},
    {5,1,2,1,2,1,2,5,2,3,2,5,5,5,5,5,5,5,1,2,1,2,5,5,1,2,1,2,3,1,2,1,2,1,1,2,1,1,2,1,2,1},
    {7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7}
  }
  
  --insert correct image and block into specific place based on above map by inserting them into tables to be drawn.
  for i,v in ipairs(map) do
    for j,w in ipairs(v) do
      if w ~= 0 then
        if w == 1 then
          table.insert(walls, Grass1((j-1)*50, (i-1)*50))
        elseif w == 2 then
          table.insert(walls, Grass2((j-1)*50, (i-1)*50))
        elseif w == 3 then
          table.insert(walls, Grass3((j-1)*50, (i-1)*50))
        elseif w == 4 then
          table.insert(objects, WallNoBottom((j-1)*50, (i-1)*50))
        elseif w == 5 then
          table.insert(walls, Dirt((j-1)*50, (i-1)*50))
        elseif w == 6 then
          table.insert(objects, Spike((j-1)*50, (i-1)*50))
        elseif w == 7 then
          table.insert(walls, DirtWithBottom((j-1)*50, (i-1)*50))
        elseif w == 8 then
          table.insert(walls, StandAloneDirt((j-1)*50, (i-1)*50))
        elseif w == 9 then
          table.insert(collectables, Coin(12 + (j-1)*50, 12 + (i-1)*50))
        end
      end
    end
  end  
end


function love.keypressed(key)
  --let player jump 
  if key == "k" then
    player:jump()
  --let player shoot
  elseif key == "j" then    
    --player.shoot(direction)
    table.insert(listOfArrows, Arrow(player.x, player.y, player.direction))
  end
  if key == "r" then  
    love.event.quit("restart")
  end
end


function love.keyreleased(key)
  if key == "k" then
    if player.gravity < -50 then
      player.gravity = -50
    end
  end
end


function love.update(dt)
  player:update(dt)
  
  if #hearts == 0 then
    love.event.quit("restart")
  end
  
  for i,v in ipairs(enemies) do
    v:update(dt)
  end
  
  for i,v in ipairs(objects) do
    v:update(dt)
  end
  
  for i,v in ipairs(walls) do
    v:update(dt)
  end
  
  for i,v in ipairs(listOfArrows) do
    --may have to change direction as it keeps getting updated
    direction = player.direction
    v:update(dt, direction)
  end
  
  --limit number of arrows in game at a time to 30
  if #listOfArrows > 30 then
    table.remove(listOfArrows, #listOfArrows - 30)
  end
  
    -- check if player has keys
  if keys > 0 then
    player.hasKey = true
  else 
    player.hasKey = false
  end
  
  for i,v in ipairs(collectables) do
    v.currentFrame = v.currentFrame + v.spinRate *dt
    if v.currentFrame >= v.maxFrames then
      v.currentFrame = 1
    end
  end

  local loop = true
  local limit = 0
  
  while loop do
    --set loop = to false so when finished resolving collisions it will stay false and stop the loop
    loop = false
    limit = limit + 1
    if limit > 100 then
      --if still not done by 100 then in an endless loop so break
      break
    end
    
    --collision between player and objects
    for i,v in ipairs(objects) do
      local collision = player:resolveCollision(v)
      if collision then
        loop = true
      end
    end
    
    -- collision for player and walls
    for i,wall in ipairs(walls) do
      local collision = player:resolveCollision(wall)
      if collision then
        loop = true
      end
    end
    
    for i,door in ipairs(doors) do
      if door.open == false then
        local collision = player:resolveCollision(door)
        if collision then
          if player.hasKey == true then
            door.currentFrame = door.currentFrame + 7 * dt
            if door.currentFrame >= door.maxFrames then
              door.open = true
              loop = true
              keys = keys - 1
              break
            end
          else 
            loop = true
          end
        end
      end
    end
    
    local collision = player:checkCollision(duck)
    if collision then
      love.event.quit("restart")
    end
      
    
    for i,enemy in ipairs(enemies) do
      local collision = player:resolveCollision(enemy)
      if collision then
        loop = true
        table.remove(hearts, #hearts)
        if player.direction == "right" then
          player.x = player.x - 100
        elseif player.direction == "left" then
          player.x = player.x + 100
        end
      end
    end
      
    for i,arrow in ipairs(listOfArrows) do
      for j=1,#enemies do  
        local deadEnemy = arrow:resolveCollision(enemies[j])
        if deadEnemy then
          table.remove(enemies, j)
          loop = true
          break
        end
      end
    end
    
    for i, wall in ipairs(walls) do
      for j,arrow in ipairs(listOfArrows) do
        local collision = arrow:resolveCollision(wall)
        if collision then
          loop = true
        end
      end
    end
                  
    for i=1,#objects-1 do
      for j=i+1,#objects do
        local collision = objects[i]:resolveCollision(objects[j])
        if collision then
          loop = true
        end
      end
    end
    for i,wall in ipairs(walls) do 
      for j,object in ipairs(objects) do
        local collision = object:resolveCollision(wall)
        if collision then
          loop = true
        end
      end
    end
    for i=1,#collectables do
      local collision = player:checkQuadCollision(collectables[i], collectables[i].frameWidth, collectables[i].frameHeight)
      if collision then
        if collectables[i].type == "coin" then
          coins = coins + 1
        elseif collectables[i].type == "key" then
          keys = keys + 1
        end 
        table.remove(collectables, i)
        break
      end
    end
  end
end


function love.draw()
  
    for i = 0, love.graphics.getWidth() / background:getWidth() do
      for j = 0, love.graphics.getHeight() / background:getHeight() do
        love.graphics.draw(background, 2 *i * background:getWidth(), 2* j * background:getHeight(), 0, 2.3, 2)
      end
    end
  
  
  love.graphics.push()
  --maid64.start()
    
    love.graphics.translate(-player.x + 960, -player.y + 540)
    --love.graphics.draw(background, 0, 0, 0, love.graphics.getWidth() / background:getWidth(), love.graphics.getHeight() / background:getHeight())
    love.graphics.draw(player.animation[math.floor(player.currentFrame)], player.x + 25, player.y, 0, player.sx, 1, player.width/2, 1)
    
    for i,v in ipairs(enemies) do
      v:draw()
    end
    for i,v in ipairs(objects) do
      v:draw()
    end
    for i,v in ipairs(walls) do 
      v:draw()
    end    
    for i,v in ipairs(listOfArrows) do
      v:draw()
    end
    for i,v in ipairs(collectables) do
      love.graphics.draw(v.image, v.frames[math.floor(v.currentFrame)], v.x, v.y, 0, 1, 1)
    end
    
    for i,v in ipairs(doors) do 
      love.graphics.draw(v.image, v.frames[math.floor(v.currentFrame)], v.x, v.y)
    end
    
    duck:draw()

    
  --maid64.finish()
  love.graphics.pop()
  
  for i,v in ipairs(hearts) do
    v:draw()
  end
  
  love.graphics.draw(HUDkey, 57, 100)
  love.graphics.print("x " .. keys, 80, 100, 0, 2, 2)
  love.graphics.draw(HUDcoin, 50, 150)
  love.graphics.print("x " .. coins, 80, 150, 0, 2, 2)
  
end