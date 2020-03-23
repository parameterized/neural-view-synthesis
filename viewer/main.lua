
camera = require 'camera'
renderer = require 'renderer'

ssx, ssy = love.graphics.getDimensions()

love.filesystem.setIdentity(love.window.getTitle())
math.randomseed(os.time())
love.math.setRandomSeed(os.time())

love.graphics.setDefaultFilter('nearest', 'nearest')

canvases = {}
shaders = {}

fonts = {
    f24 = love.graphics.newFont(24),
    f32 = love.graphics.newFont(32)
}

function love.load()
    camera.load()
    renderer.load()
    fpsLimit = 60
    fpsTimer = 0
end

function love.update(dt)
    camera.update(dt)

    fpsTimer = fpsTimer - dt
    if fpsLimit <= 0 or fpsTimer < 0 then
        fpsTimer = fpsTimer + 1 / math.max(fpsLimit, 1)
        renderer.updateImage()
    end
    
    love.window.setTitle('Neural View Synthesis (' .. love.timer.getFPS() .. ' FPS)')
end

function love.mousepressed(x, y, btn, isTouch)
    if btn == 2 then
        love.mouse.setRelativeMode(true)
    end
end

function love.mousereleased(x, y, btn, isTouch)
    if btn == 2 then
        love.mouse.setRelativeMode(false)
    end
end

function love.mousemoved(x, y, dx, dy)
    if love.mouse.isDown(2) then
        camera.turn(dx, dy)
    end
end

function love.keypressed(k, scancode, isRepeat)
    if k == 'escape' then
        love.event.quit()
    elseif k == 'r' then
        camera.load()
    end
end

function love.draw()
    love.graphics.clear(0.8, 0.8, 0.8)
    renderer.draw()
end
