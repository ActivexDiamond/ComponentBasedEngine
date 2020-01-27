local class = require "libs.cruxclass"
local Mob = require "template.Mob"
local IHealth = require "behavior.IHealth"
local IHittable = require "behavior.IHittable"
local IBoundingBox = require "behavior.IBoundingBox"

local MathUtils = require "libs.MathUtils"

local Game = require "core.Game"
--local Registry = require "istats.Registry"

------------------------------ Helper Methods ------------------------------

local function repath(self, f)
	local obj = f:getUserData()
	if obj:getId() ~= "player" then return true
	else
		local x, y =  self:getPos()
		local px, py = obj:getPos()
		
		if px < x then self.path = Mob.LEFT
		elseif x < px then self.path = Mob.RIGHT
		else self.path = Mob.HLT end
		
		if py < y  then self:_jump() end
		
		return false
	end
end

------------------------------ Constructor ------------------------------ 
local Zombie = class("Zombie", Mob):include(IHealth, IHittable)
function Zombie:init(x, y)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
	Mob.init(self, "zombie", x, y)
	self:addCategory(IBoundingBox.categories.HOSTILE_MOB)
	self:addMask(IBoundingBox.categories.PLAYER)
	self.path = Mob.LEFT
--	print(self.fixture:getFilterData())
end

------------------------------ Main Methods ------------------------------
function Zombie:tick(dt)
	Mob.tick(self, dt)	
	local vx, vy = self.body:getLinearVelocity()
--	if vx == 0 then repath(self) end
	local wx, wy = 32 * Game.GRID, 32 * Game.GRID
	
	Game.world:queryBoundingBox(0, 0, wx, wy, function(f) return repath(self, f) end)
	self:_walk(self.path, false, dt)
	
--	self:hurt(0.2)
--	print(self:getHealth())
end

function Zombie:draw(g)
	g.setColor(0, 0.25, 0, 1)
	g.polygon('fill', self.body:getWorldPoints(self.shape:getPoints()))
	
	local health, healthMax = self:getHealth(), self:getMaxHealth()
	local x, y, w, h = self:getX(), self:getY(), self:getW(), self:getH()
	x = x + 0.1
	y = y - 0.2
	w = (w - 0.2) * MathUtils.map(health, 0, healthMax, 0, 1)
	h = 0.15

	local r, gr, b, a = 1, 1, 0, 1
	r = MathUtils.map(health, 0, healthMax, 1, 0)
	gr = MathUtils.map(health, 0, healthMax, 0, 1)
	
	g.setColor(r, gr, b, a)
	g.rectangle('fill', x, y, w, h)
end

return Zombie