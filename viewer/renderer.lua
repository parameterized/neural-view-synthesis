
local renderer = {}

local function nc32(w, h)
    return love.graphics.newCanvas(w, h, { format='rgba32f' })
end

function renderer.load()
    canvases.h = nc32(64 * 64 / 4, 64)
    canvases.y = nc32(64, 64)

    shaders.h = love.graphics.newShader('shaders/h.glsl')
    shaders.y = love.graphics.newShader('shaders/y.glsl')

    renderer.loadWeights()
end

function renderer.loadWeights()
    local ok, weights = pcall(dofile, 'data/weights_v1.lua')
    if ok then
        local dense1 = love.image.newImageData(6 + 1, 64 / 4, 'rgba32f')
        local dense2 = love.image.newImageData(64 + 1, 1, 'rgba32f')
        for j=1, 64 / 4 do
            local j0 = (j - 1) * 4
            local w = weights.d1_kernel
            for i=1, 6 do
                dense1:setPixel(i - 1, j - 1, w[i][j0 + 1], w[i][j0 + 2], w[i][j0 + 3], w[i][j0 + 4])
            end
            local b = weights.d1_bias
            dense1:setPixel(6, j - 1, b[j0 + 1], b[j0 + 2], b[j0 + 3], b[j0 + 4])
        end
        do
            local w = weights.d2_kernel
            for i=1, 64 do
                dense2:setPixel(i - 1, 0, w[i][1], w[i][2], w[i][3], 0)
            end
            local b = weights.d2_bias
            dense2:setPixel(64, 0, b[1], b[2], b[3], 0)
        end
        shaders.h:send('dense1', love.graphics.newImage(dense1))
        shaders.y:send('dense2', love.graphics.newImage(dense2))

        renderer.weightsLoaded = true
    end
end

function renderer.updateImage()
    if renderer.weightsLoaded then
        local p = camera.pos
        local t = camera.target
        shaders.h:send('camPos', { p.x, p.y, p.z })
        shaders.h:send('camTarget', { t.x, t.y, t.z })

        love.graphics.setColor(1, 1, 1)
        love.graphics.setBlendMode('replace', 'premultiplied')

        -- get h
        love.graphics.setCanvas(canvases.h)
        love.graphics.clear()
        love.graphics.setShader(shaders.h)
        love.graphics.rectangle('fill', 0, 0, canvases.h:getDimensions())

        -- get y
        love.graphics.setCanvas(canvases.y)
        love.graphics.setShader() -- todo: test if clear uses shader, remove if it doesn't
        love.graphics.clear() -- todo: test if replace makes clear redundant
        love.graphics.setShader(shaders.y)
        shaders.y:send('h', canvases.h)
        love.graphics.rectangle('fill', 0, 0, canvases.y:getDimensions())

        love.graphics.setShader()
        love.graphics.setCanvas()
        love.graphics.setBlendMode('alpha', 'alphamultiply')
    end
end

function renderer.draw()
    if renderer.weightsLoaded then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(canvases.y, ssx / 2, ssy / 2, 0, 8, 8, 32, 32)
    else
        love.graphics.setColor(0, 0, 0)
        love.graphics.setFont(fonts.f24)
        local text = 'Weights not loaded'
        love.graphics.print(text, ssx / 2 - fonts.f24:getWidth(text) / 2, ssy / 2 - fonts.f24:getHeight() / 2)
    end
end

return renderer
