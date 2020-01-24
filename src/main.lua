--require "box2dMeterTest"
---[[

local Block = require "template.Block"
local Entity = require "template.Entity"
local Player = require "template.Player"
local Zombie = require "template.Zombie"

local Evsys = require "evsys.Evsys"
local KeypressEvent = require "evsys.input.KeypressEvent"

local Scheduler = require "utils.Scheduler"
local Game = require "core.Game"

local blocks = {}
local player
local zombie, zombie1, zombie2

function love.load()
	local grid = {0, 0,
		2, 2,
		18, 13,
		9, 9,
		8, 8,
		4, 4,
--		20, 14,
		21, 15,
		
		3, 8,
		3, 10,
		
		3, 11,
		3, 12,	4, 12,
		3, 13,	4, 13,	5, 13,
		3, 14,	4, 14,	5, 14,	6, 14,
		3, 15,	4, 15,	5, 15,	6, 15,	7, 15,
	}

	for i = 1, 20 do
		local x, y = 2 + i, 16 
		table.insert(grid, x)
		table.insert(grid, y)
	end	
	
	for i = 1, 20 do
		local x, y = 22, i
		table.insert(grid, x)
		table.insert(grid, y)
		
		local x, y = 2, i
		table.insert(grid, x)
		table.insert(grid, y)
	end	
		
	for i = 1, #grid, 2 do
		table.insert(blocks, 
			Block("andesiteStoneblock", grid[i], grid[i + 1])) 
	end	
	
	player = Player(12, 12)
	zombie = Zombie(16, 12)
	zombie1 = Zombie(17, 12)
	zombie2 = Zombie(18, 12)
	
	print ((15 / 30) % 1)
	print (4.3 % 2)
	print (1.3 % 2)
	x = 0
	function f0() 
		x = x + 1
		print ("ping:" .. x)
	end
	
	function f1(...) f0(); print(...) end
	
--	Scheduler:callAfter(5, f0)
--	Scheduler:callAfter(6, f1)
--	Scheduler:callAfter(6, f1, {'x'})

--	Scheduler:callFor(0.5, f0)
	
--	Scheduler:callEveryFor(1, 10, f1)
	Scheduler:callEveryFor(0.1, 1, f1)
	
--	Scheduler:callEveryFor(0.1, 1, f0)
	
--	Scheduler:callFor(6, f1)
--	Scheduler:callFor(6, f1, {'x'})

	function rect()
		print('rect')
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.rectangle('fill', 3, 3, 3, 3)
	end
	
	Scheduler:callFor(30, rect)
end

local dir = 0;
function love.update(dt)
	Game:tick(dt)
	
	player:tick(dt)
	zombie:tick(dt)
	zombie1:tick(dt)
	zombie2:tick(dt)
	Scheduler:tick(dt)
	Evsys:poll()
end

local clicks = 0
function love.draw()
	local g = love.graphics;
	g.scale(Game.MS)
	
	for _, v in ipairs(blocks) do		
		v:draw(g)
	end
	
	player:draw(g)
	zombie:draw(g)
	zombie1:draw(g)
	zombie2:draw(g)
	
	g.setColor(1, 1, 1, 1)
	g.scale(1/Game.MS)
	local vx, vy = player.body:getLinearVelocity()
	local str = string.format("vx: %f | vy: %f ", vx, vy) 
	g.print(str, 40, 80)
	
	local s = player.state;
	local air = s:is(Player.AIRBORNE)
	local str = string.format("Player.AIRBORNE: %s", air) 
	g.print(str, 40, 100)
	
	local jump = s:is(Player.JUMPING)
	local str = string.format("Player.JUMPING: %s", jump) 
	g.print(str, 40, 120)
	
	local jr = player.jumpsRemaining
	local str = string.format("Player.jumpsRemaining: %d", jr) 
	g.print(str, 40, 140)
	
	local ej = player.extraJumps
	local str = string.format("Player.extraRemaining: %d", ej) 
	g.print(str, 40, 160)
	
	str = string.format("grid: %d, %d", Game:scaledSnap(mousex) / Game.GRID, 
		Game:scaledSnap(mousey) / Game.GRID)
	g.print(str, 40, 180)
end


function love.keypressed(k, code, isrepeat)
	Evsys:queue(KeypressEvent(k))
	clicks = clicks + 1
end

mousex, mousey = 0, 0
function love.mousemoved(x, y, dx, dy, istouch)
	mousex, mousey = x, y
end
   
    
--]]