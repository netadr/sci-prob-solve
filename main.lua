assets = require('lib/cargo').init('assets')
middleclass = require('lib/middleclass')
stateful = require('lib/stateful')

require 'scripts/game'

local game_instance

function love.load()
    game_instance = game:new()
end

function love.update(dt)
    game_instance:update(dt)
end

function love.draw()
    game_instance:draw()
end

function love.keypressed(key, code)
    game_instance:keypressed(key, code)
end

function love.mousepressed(x, y, button, istouch)
    game_instance:mousepressed(x, y, button, istouch)
end
