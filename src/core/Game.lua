local class = require "libs.cruxclass"
local Timer = require "utils.Timer"

--local Thing = require "template.Thing"
--local IBoundingBox = require "behavior.IBoundingBox"
--local Registry = require "istats.Registry"

local Game = class("Game")
function Game:init()
	love.physics.setMeter(1)
	self.world = love.physics.newWorld(Game.GRAVITY_X, Game.GRAVITY_Y)
	
	self.timer = Timer()
end

---Constants

Game.GRID = 32
Game.MS = Game.GRID

Game.GRAVITY_X = 0
Game.GRAVITY_Y = 25

Game.graphics = {}
do
	local g = Game.graphics
	g.GUI_SCALE = 0.75
	g.ITEM_W, g.ITEM_H = 48, 48

	g.CELL_PAD_X, g.CELL_PAD_Y = 4, 4	--space between slot-borders and item inside of it.
	g.CELL_W = g.ITEM_W + g.CELL_PAD_X
	g.CELL_H = g.ITEM_H + g.CELL_PAD_Y
	
	g.INV_PAD = 4						--space between slots
end
---Core
function Game:tick(dt)
	self.world:update(dt)
	self.timer:tick(dt)
end

function Game:draw()
end

---Utils
function Game:scaledSnap(x)
	return math.floor(x / Game.GRID) * Game.GRID
end

function Game:snap(x)
	return math.floor(x)
end

---Getters
function Game:getLoadedWorld()
	return self.world
end

function Game:getM()
	return self.m
end

--function Game:getGridW()
--	return Game.GRID
--end
--
--function Game:getGridH()
--	return Game.GRID
--end

return Game()

--[[
Needed methods:

getLoadedWorld
getGridW
getGridH

Note: Is a singleton

return Game() -- this script should return an instance of
	Game, the only one; providing no access to the class's init.
	(Possibly requiring to forbid access to the class in it's entirety)
--]]