--require "box2dMeterTest"
---[[
local Game = require "core.Game"
local Block = require "template.Block"
local Entity = require "template.Entity"
local Player = require "template.Player"

local Evsys = require "evsys.Evsys"
local KeypressEvent = require "evsys.input.KeypressEvent"

local blocks = {}
local player
function love.load()
	local grid = {0, 0,
		2, 2,
		18, 13,
		9, 9,
		8, 8,
		4, 4,
--		20, 14,
		21, 15,
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
end

local dir = 0;
function love.update(dt)
	Game:tick(dt)
	
	player:tick(dt)
	Evsys:poll()
end

local clicks = 0
function love.draw()
	local g = love.graphics;
	g.scale(Game.MS)
	
	for _, v in ipairs(blocks) do		
		g.setColor(1, 0, 0)
		g.polygon('fill', v.body:getWorldPoints(v.shape:getPoints()))
	end
	
	g.setColor(1, 1, 1, 0.5)
	g.setColor(1, 0, 0, 0.5)
	g.polygon('fill', player.body:getWorldPoints(player.shape:getPoints()))
	
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