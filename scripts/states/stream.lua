local stream = game:addState('stream')

local theme = assets.sounds.theme
local ecolideath = assets.sounds.ecolideath
local background = assets.images.stream
local standing = assets.images.player_standing
local walking = assets.images.player_walking
local attacking = assets.images.player_attacking
local ecoli = assets.images.ecoli
local heart = assets.images.heart
local pixeboy = assets.fonts.pixeboy(36)


local standing_anim = {}
standing_anim[1] = love.graphics.newQuad(0, 0, standing:getWidth(), standing:getHeight(), standing:getDimensions())

local walking_anim = {}
walking_anim[1] = love.graphics.newQuad(0, 0, 27, 49, walking:getDimensions())
walking_anim[2] = love.graphics.newQuad(33, 0, 19, 49, walking:getDimensions())
walking_anim[3] = love.graphics.newQuad(61, 0, 19, 49, walking:getDimensions())
walking_anim[4] = love.graphics.newQuad(87, 0, 27, 49, walking:getDimensions())

local attacking_anim = {}
attacking_anim[1] = love.graphics.newQuad(0, 0, 36, 48, attacking:getDimensions())
attacking_anim[2] = love.graphics.newQuad(43, 0, 46, 48, attacking:getDimensions())
attacking_anim[3] = love.graphics.newQuad(93, 0, 46, 48, attacking:getDimensions())

local player = {
    x = 500,
    y = 300,
    speed = 300,
    health = 3,
    image = standing,
    anim = standing_anim,
}

local level = {
    stage = 1,
    speed = 1, 
    init = false,
    enemies = {},
}

local current_frame = 1
local scale = 5

function stream:enteredState()    
    background:setFilter("nearest", "nearest")
    standing:setFilter("nearest", "nearest")
    walking:setFilter("nearest", "nearest")
    attacking:setFilter("nearest", "nearest")
    heart:setFilter("nearest", "nearest")
end

function stream:update(dt)
    -- Update frame for spritesheets
    current_frame = current_frame + (dt * 6)

    -- Ensure theme is playing
    if not theme:isPlaying() then
        theme:play()
    end

    -- Set up enemies if they haven't been yet
    if not level.init then
        initLevel()
        level.init = true
    end

    -- Handle player input
    if love.keyboard.isDown('d') then
		if player.x < love.graphics.getWidth() then
            player.image = walking
            player.anim = walking_anim
			player.x = player.x + (player.speed * dt)
            scale = -5
		end
	elseif love.keyboard.isDown('a') then
		if player.x > 0 then
            player.image = walking
            player.anim = walking_anim 
			player.x = player.x - (player.speed * dt)
            scale = 5
		end
    elseif love.keyboard.isDown('w') then
        if player.y > 150 then
            player.image = walking
            player.anim = walking_anim
            player.y = player.y - (player.speed * dt)
        end
    elseif love.keyboard.isDown('s') then
        if player.y < (love.graphics.getHeight()) then
            player.image = walking
            player.anim = walking_anim
            player.y = player.y + (player.speed * dt)
        end
    elseif love.keyboard.isDown('space') then
        player.image = attacking
        player.anim = attacking_anim
        checkAttack()
    else 
        player.image = standing
        player.anim = standing_anim
	end

    -- Check if all enemies were killed
    if #level.enemies == 0 and level.init == true and level.stage < 3 then
        level.stage = level.stage + 1
        level.speed = level.speed * 1.5
        level.init = false
    end

    -- Check if player recieves damage 
    for k, v in pairs(level.enemies) do 
        x_diff = math.abs(v.x - player.x)
        y_diff = math.abs(v.y - player.y)

        if x_diff <= 25 and y_diff <= 50 then 
            player.health = player.health - 1
        end
    end
    
    -- Move enemies
    for k, v in pairs(level.enemies) do
        if v.x > 0 then
            v.x = v.x - (5 * level.speed)
        else
            v.x = love.graphics.getWidth() + 100
        end
    end

    -- Ensure that current_frame does not exceed the number of frames in the current active spritesheet
    if current_frame > #player.anim then
        current_frame = 1
    end
end

function stream:draw()
    love.graphics.setFont(pixeboy)

    love.graphics.draw(background, 0, 0, 0, 5)

    for k, v in pairs(level.enemies) do
        love.graphics.draw(ecoli, v.x, v.y, 0, -5, 5)
    end

    love.graphics.draw(player.image, player.anim[math.floor(current_frame)], player.x, player.y, 0, scale, 5)

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, 125, 110)
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("LEVEL " .. level.stage, 5, 5)
    love.graphics.draw(ecoli, 4, 40)
    love.graphics.print("X " .. #level.enemies, 32, 42)
    if player.health == 3 then
        love.graphics.draw(heart, 4, 75, 0, 2)
    end
end

function stream:keypressed(key, code)
end

function initLevel()
    if level.stage == 1 then
        table.insert(level.enemies, {x = 100, y = 500,})
        table.insert(level.enemies, {x = 200, y = 400,})
    elseif level.stage == 2 then
        table.insert(level.enemies, {x = (love.graphics.getWidth() + 50), y = 700,})
        table.insert(level.enemies, {x = (love.graphics.getWidth() + 100), y = 450,})
        table.insert(level.enemies, {x = (love.graphics.getWidth() + 300), y = 450,})
    end
end

function checkAttack()
    local to_remove = {}
    for k, v in pairs(level.enemies) do
        x_diff = math.abs(v.x - player.x)
        y_diff = math.abs(v.y - player.y)

        if x_diff <= 50 and y_diff <= 100 then
            table.insert(to_remove, k)
        end
    end

    for k, v in pairs(to_remove) do
        ecolideath:play()
        table.remove(level.enemies, v)
    end
end
