
local camera = {}

function camera.load()
	camera.pos = { x=-3.7, y=-1.6, z=-0.3 }
	camera.rot = { x=0, y=0.2, z=0 }
    camera.target = nil -- set in update
    camera.moveSpeed = 2
    camera.turnSpeed = 1 / 200
end

function camera.update(dt)
    local speed = camera.moveSpeed
    if love.keyboard.isScancodeDown('lctrl') then
        speed = speed / 6
    elseif love.keyboard.isScancodeDown('lshift') then
        speed = speed * 6
    end

	if love.keyboard.isScancodeDown('space') then
		camera.pos.y = camera.pos.y - speed * dt
	end

	local x, y, z = -math.cos(camera.rot.y), 0, math.sin(camera.rot.y)

	if love.keyboard.isScancodeDown('d') then
		camera.pos.x = camera.pos.x - x * speed * dt
		camera.pos.y = camera.pos.y - y * speed * dt
		camera.pos.z = camera.pos.z - z * speed * dt
	elseif love.keyboard.isScancodeDown('a') then
		camera.pos.x = camera.pos.x + x * speed * dt
		camera.pos.y = camera.pos.y + y * speed * dt
		camera.pos.z = camera.pos.z + z * speed * dt
	end

	local zp = math.cos(camera.rot.x)
	x, y, z = zp * math.sin(camera.rot.y), -math.sin(camera.rot.x), zp * math.cos(camera.rot.y)

	if love.keyboard.isScancodeDown('w') then
		camera.pos.x = camera.pos.x + x * speed * dt
		camera.pos.y = camera.pos.y + y * speed * dt
		camera.pos.z = camera.pos.z + z * speed * dt
	elseif love.keyboard.isScancodeDown('s') then
		camera.pos.x = camera.pos.x - x * speed * dt
		camera.pos.y = camera.pos.y - y * speed * dt
		camera.pos.z = camera.pos.z - z * speed * dt
	end

	camera.target = {
        x = camera.pos.x + x,
        y = camera.pos.y + y,
        z = camera.pos.z + z
    }
end

function camera.turn(dx, dy)
    camera.rot.y = camera.rot.y + dx * camera.turnSpeed
    camera.rot.x = camera.rot.x - dy * camera.turnSpeed
	camera.rot.x = math.min(math.max(camera.rot.x, -math.pi / 2 + 0.001), math.pi / 2 - 0.001)
end

return camera
