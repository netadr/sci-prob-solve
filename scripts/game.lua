game = middleclass('game'):include(stateful)

require 'scripts/states/intro'
require 'scripts/states/stream'
require 'scripts/states/game_over'
require 'scripts/states/outro'

function game:initialize()
    self:gotoState('intro')
end
  
function game:exit()
end

function game:update(dt)
end

function game:draw()
end

function game:keypressed(key, code)
end

function game:mousepressed(x, y, button, isTouch)
end
