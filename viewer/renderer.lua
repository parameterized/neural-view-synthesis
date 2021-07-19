
local renderer = {}

local function nc32(w, h)
    return love.graphics.newCanvas(w, h, { format='rgba32f' })
end

function renderer.load()
    renderer.canvases = {nc32(256 * 13, 256)}
    renderer.shaders = {love.graphics.newShader('shaders/x.glsl')}
    renderer.shaders[1]:send('screenSize', { 256, 256 })
    nFeats = 64
    for i=1, 6 do
        if i == 6 then
            table.insert(renderer.canvases, love.graphics.newCanvas(256, 256))
        else
            table.insert(renderer.canvases, nc32(256 * 64 / 4, 256))
        end
        table.insert(renderer.shaders, love.graphics.newShader('shaders/l' .. i-1 .. '.glsl'))
        renderer.shaders[#renderer.shaders]:send('screenSize', { 256, 256 })
    end
end

function renderer.updateImage()
    local p = camera.pos
    local t = camera.target
    renderer.shaders[1]:send('camPos', { p.x, p.y, p.z })
    renderer.shaders[1]:send('camTarget', { t.x, t.y, t.z })

    love.graphics.setColor(1, 1, 1)
    love.graphics.setBlendMode('replace', 'premultiplied')

    for i=1, #renderer.shaders do
        love.graphics.setCanvas(renderer.canvases[i])
        love.graphics.setShader(renderer.shaders[i])
        if i > 1 then
            renderer.shaders[i]:send('h', renderer.canvases[i-1])
        end
        love.graphics.rectangle('fill', 0, 0, renderer.canvases[i]:getDimensions())
    end

    love.graphics.setShader()
    love.graphics.setCanvas()
    love.graphics.setBlendMode('alpha', 'alphamultiply')
end

function renderer.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(renderer.canvases[#renderer.canvases],
        ssx / 2, ssy / 2, 0, 2, 2, 128, 128)
end

return renderer
