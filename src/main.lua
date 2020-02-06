--require "suitTest"
--require "box2dMeterTest"

---[[
require "DEBUG"
require "globals"

local Registry = require "istats.Registry"

local Block = require "template.Block"
local Entity = require "template.Entity"
local Player = require "template.Player"
local Zombie = require "template.Zombie"

local Evsys = require "evsys.Evsys"
local KeypressEvent = require "evsys.input.KeypressEvent"

local Item = require "template.Item"
local ItemStack = require "inv.ItemStack"
local Slot = require "inv.Slot"
local Inventory = require "inv.Inventory"

local Scheduler = require "utils.Scheduler"
local Game = require "core.Game"

local blocks = {}
local player
local zombie, zombie1, zombie2

function love.load()

	local grid = {
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
			Block("andesite|block", grid[i], grid[i + 1])) 
	end	
	
	player = Player(12, 12)
	Game.player = player
	zombie = Zombie(16, 12)
--	zombie1 = Zombie(17, 12)
--	zombie2 = Zombie(18, 12)	
--	local interval, total = -1, 0.5
--	local interval, total = 0.5, 5
--	function getClosure0(dt, ...)
--		local tdt = 0
--		local fdt = 0
--		local x = 0
--		return function (dt)
--			x = x + 1
--			print('ping' .. x)
--			
--			if x == 1 then fdt = dt end
--			tdt = tdt + dt 
--			local round = interval == -1 and 0 or interval
--			local per = math.min(tdt / (total - round), 1)
--			local per = tdt / (total - round)
--			print('dt', dt, 'tdt', tdt, 'per', per)
--		end
--	end
--
--	local getTime = love.timer.getTime
--	function getClosure1(dt, ...)
--		local stamp = getTime()
--		local x = 0
--		return function (dt)
--			x = x + 1
--			print('ping' .. x)
--			local tdt = getTime() - stamp
--			local round = interval == -1 and 0 or interval
--			local per = math.min(tdt / (total - round), 1)
--			local per = tdt / (total - round)
--			print('dt', dt, 'tdt', tdt, 'per', per)
--		end
--	end
--		
--	function getClosure2(dt, ...)
--		local tdt = 0
--		return function (dt)
--			tdt = tdt + dt 
--			local round = interval == -1 and 0 or interval
--			local per = math.min(tdt / (total - round), 1)
--			local per = tdt / (total - round)
--			print('dt', dt, 'tdt', tdt, 'per', per)
--		end
--	end
--	Scheduler:callEveryFor(interval, total, getClosure0())
--
--	Scheduler:callEveryFor(interval, total, getClosure0(), nil, function()
--		print('-----------------')
--		Scheduler:callEveryFor(interval, total, getClosure1()) 
--	end)
--	
--	p = 0
--	function f3(dt, per)
--		p = p + 1
--		print('ping' .. p, 'dt', dt, 'per', per)
--	end
--	
--	Scheduler:callEveryFor(interval, total, f3)
--	
--	DEBUG / TEST CODE
--print ((15 / 30) % 1)
--	print (4.3 % 2)
--	print (1.3 % 2)
--	x = 0
--	function f0() 
--		x = x + 1
--		print ("ping:" .. x)
--	end
--	
--	function f1(...) f0(); print(...) end
--	
--	function done(x) print("WRAPUP: ", x) end 
--	
--	Scheduler:callAfter(5, f0)
--	Scheduler:callAfter(6, f1)
--	Scheduler:callAfter(6, f1, {'x'})
--
--	Scheduler:callFor(0.5, f0)
--	
--	Scheduler:callEveryFor(1, 10, f1)
--	Scheduler:callEveryFor(0.1, 1, f1)
--	
--	Scheduler:callAfter(2, f0, nil, done, 42)
--	Scheduler:callFor(0.1, f0, nil, done, 42)
--	Scheduler:callEvery(0.5, f0, nil, done, 42)
--	Scheduler:callEveryFor(0.1, 1, f0, nil, done, 42)
--
--	Scheduler:callFor(6, f1)
--	Scheduler:callFor(6, f1, {'x'})
--
--	
--	area = {3, 4, 5, 6}
--	print(1, 2, unpack(area), 7, 8)
--	
--	function test(...)
--		args = {...}
--		print(unpack(args), 3)
--	end
--	test(1, 2)
--	
--	function rect()
--		print('rect')
--		love.graphics.setColor(1, 1, 1, 1)
--		love.graphics.rectangle('fill', 3, 3, 3, 3)
--	end
--	Scheduler:gCallEveryFor(2, 30, rect)

end

--local function cleanupArgs(from) 
--
--end
--
--local function combineItem(item, ...)
--	print("combineItem", item, ...)
--end
--
--local function combineNumber(n, ...) 
--	print("combineNumber", n, ...)
--end
--
--local function combineTable(t, ...) 
--	print("combineTable", t, ...)
--end
--
--local function combineString(str, ...) 
--	print("combineString", str, ...)
--end
--
--local function combineTableString(t, str, ...) 
--	print("combineTableString", t, str, ...)
--end
--
--local function combine(...)
--	return utils.ovld({...},		--args
--			{cleanupArgs},			--optional cleanup function[1]
--			combineItem, {Item},
--			combineTableString, {'t', 's'},
--			combineTable, {'t'},
--			combineString, {'s'},
--			combineNumber, {'n'}
--		)
--
--
--end
--combine(1,  2,  3)
--combine({x = 3},  2, 3)
--combine(-1, "str", "str2", 2, 3, "str3")
--combine({x = 30},  "strT", 20, 30)
--
--local log = Item("logOak")
--combine(1, log, 3)

local log = Item("oak|log")
local stack = ItemStack(log)
local slot = Slot(nil, nil, stack)

local slots = {}
for i = 1, 8 do
	table.insert(slots, slot)
end

slots = {
	Slot{itemStack = ItemStack(Item("oak|log"), 4)},
	Slot{itemStack = ItemStack(Item("wood|stick"), 2)},
	Slot{itemStack = ItemStack(Item("coal|oredrop"), 64)},
	Slot{itemStack = ItemStack(Item("iron|ingot"))},
	Slot{itemStack = ItemStack(Item("iron|plate"))},
	Slot{itemStack = ItemStack(Item("iron|stick"))},
}

local inv = Inventory{x = 200, y = 200,
		cols = 10, rows = 4, 
		slots = slots}

local coalStack = ItemStack(Item("coal|oredrop"), 64)
local mouseInv = Inventory{slots = Slot{itemStack = coalStack,
		noBg = true, noHit = true}}


function love.update(dt)
	local s = Game.graphics.GUI_SCALE
	mouseInv:setPos(love.mouse.getX()/s, love.mouse.getY()/s)

	Game:tick(dt)

	player:tick(dt)
	zombie:tick(dt)
--	zombie1:tick(dt)
--	zombie2:tick(dt)
	inv:tickGui()
	mouseInv:tickGui()
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
	
	Scheduler:draw(g)
	
	player:draw(g)
	zombie:draw(g)
--	zombie1:draw(g)
--	zombie2:draw(g)
	
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
	
	str = string.format("grid: %d, %d", Game:scaledSnap(love.mouse.getX()) / Game.GRID, 
		Game:scaledSnap(love.mouse.getY()) / Game.GRID)
	g.print(str, 40, 180)
	
	g.scale(Game.graphics.GUI_SCALE)
	inv:drawGui()
	mouseInv:drawGui()
	g.scale(1/Game.graphics.GUI_SCALE)
	
end


function love.keypressed(k, code, isrepeat)
	Evsys:queue(KeypressEvent(k))
	clicks = clicks + 1
end
    
--]]