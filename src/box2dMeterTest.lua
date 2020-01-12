local p, g, k = love.physics, love.graphics, love.keyboard
love.window.setPosition(8, 30, 2)
local MS, OTHER;

local function createObject(x, y, w, h, world, typ, t)
	local b = p.newBody(world, x, y, typ)
	local s = p.newRectangleShape(w / 2, h / 2, w, h)
	local f = p.newFixture(b, s)
	local col = ((type(t.col) == 'table' and
		type(t.col[#t + 1]) == 'table' and
		t.col[#t + 1]) or t.col) or {0.7, 0.7, 0.7, 1}

	local function draw()
		g.setColor(col)
		g.polygon('fill', b:getWorldPoints(s:getPoints()))
	end

	t[#t + 1] = {b = b, s = s, f = f, draw = draw}
end

local function createBlock(x, y, w, h, world, t)
	createObject(x, y, w, h, world, 'static', t)
end
local function createEntity(x, y, w, h, world, t)
	createObject(x, y, w, h, world, 'dynamic', t)
end

local function set(ms)
	p.setMeter(ms)
	print('Set MS to:', p.getMeter())
end

local world;
local wall = {}
local function createWalls()
	local lx, rx, gx = 2, 20, 2
	local wy, gy = 2, 16
	local w, h = 1, 1
	local ex, ey = 10, 8
	
	createBlock(lx, wy, w, h * 14, world, wall)	--left
	createBlock(rx, wy, w, h * 14, world, wall)	--right
	createBlock(gx, gy, rx - w, h, world, wall)	--ground
	createEntity(ex, ey, w, h, world, wall)
	
--	createBlock(320, 512, 32, 32, world, wall)
--	createEntity(320, 256, 32, 32, world, wall)
end

local _32 = true
MS = _32 and 32 or 1
OTHER = _32 and 1 or 32

local xgravity, ygravity = 0, 9.8 --* MS
local canSleep = false

function love.load()
	set(1)
	print('creating world, setting gravity.')
	world = p.newWorld(xgravity, ygravity, canSleep)
	print(world:getGravity())
	
--	set(OTHER)	
	print('creating walls and entity.')
	createWalls()
end

function love.update(dt)
	world:update(dt)
end

function love.draw()
	g.scale(MS, MS)
	for k, v in ipairs(wall) do v:draw() end
end




