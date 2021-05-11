local intro = game:addState('intro')

local text_base = 575
local pixeboy = assets.fonts.pixeboy(54)
local watershed = assets.images.watershed
local ecoli = assets.images.ecoli

function intro:enteredState()
    watershed:setFilter("nearest", "nearest")
    ecoli:setFilter("nearest", "nearest")
end

function intro:update(dt)
end

function intro:draw()
    love.graphics.setFont(pixeboy)
    love.graphics.print("Beaver Creek is infested with E.coli!", 0, text_base)
    love.graphics.print("The amount is up to 630 CFU/mL, which is dangerous for life!", 0, text_base + 50)
    love.graphics.print("You must eliminate all traces of it from the stream!", 0, text_base + 100)
    love.graphics.print("Press space to continue.", 0, text_base + 150)
    love.graphics.draw(assets.images.watershed, 150, 100)
    love.graphics.draw(assets.images.ecoli, 650, 100, 0, 15)
end

function intro:keypressed(key, code)
    if key == 'space' then
        self:gotoState('stream')
    end
end
