
local shtest = {}

function shtest.load()
    canvases.shtest = love.graphics.newCanvas(512, 512)
    shaders.shtest = love.graphics.newShader('shaders/shtest.glsl')
    
    shVals = {}
    for k=1, 3 do
        shVals[k] = {}
        for i=1, 25 do
            shVals[k][i] = love.math.random() - 0.5
        end
    end
    shaders.shtest:send('shValsR', unpack(shVals[1]))
    shaders.shtest:send('shValsG', unpack(shVals[2]))
    shaders.shtest:send('shValsB', unpack(shVals[3]))
end

function shtest.updateImage()
    local p = camera.pos
    local t = camera.target
    shaders.shtest:send('camPos', { p.x, p.y, p.z })
    shaders.shtest:send('camTarget', { t.x, t.y, t.z })

    love.graphics.setCanvas(canvases.shtest)
    love.graphics.setShader(shaders.shtest)
    love.graphics.rectangle('fill', 0, 0, 512, 512)

    love.graphics.setShader()
    love.graphics.setCanvas()
end

function shtest.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(canvases.shtest, ssx / 2, ssy / 2, 0, 1, 1, 256, 256)
end

return shtest
