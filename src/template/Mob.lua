local class = require "libs.cruxclass"
local Entity = require "template.Entity"
local MultiState = require "core.MultiState"
--local Game = require "core.Game"
--local Registry = require "istats.Registry"

------------------------------ Helper Methods ------------------------------
local function sign(x)
	return x > 0 and 1 or x < 0 and -1 or 0
end
local function reqF(s, v, m, dt)
	local x = s - v;	
	if (0 > s and s > v) or (0 < s and s < v) then x = 0 end
	local a = x/dt
	local f = a*m
	return f
end

------------------------------ Constructor ------------------------------
local Mob = class("Mob", Entity)
function Entity:init(id, x, y)
	Entity.init(self, id, x, y)	
end

------------------------------ Constants ------------------------------
Mob.LEFT = -1
Mob.RIGHT = 1

Mob.MOTIONLESS, Mob.MOVING,
Mob.CRAWLING, Mob.WALKING, 
Mob.AIRBORNE, Mob.JUMPING, 
Mob.FLYING, Mob.CLIMBING = MultiState:create()

------------------------------ Movement Methods ------------------------------
local function move(self, sx, sy, dt)
	local m = self.body:getMass()
	local vx, vy = self.body:getLinearVelocity()
	---For an axis that is passed as nil, f = 0.
	local fx, fy = sx and reqF(sx, vx, m, dt) or 0, sy and reqF(sy, vy, m, dt) or 0
	self.body:applyForce(fx, fy)
end
--[[
	final equation:
		[dif] x = s - v
		if (s neg AND s > v) OR (s pos AND s < v)
			x = 0
		f = toForce(x)
		body->applyForce(f)

	goal:
	move -> vel >= speed (aka max moving velocity)
		get current vel
		get goal vel (speed)
			if vel >= speed ; 
				do nothing
			if vel < speed ; 
				apply enough force to accelerate 
				to speed in 1 tick
	=> go from 'goal velocity' (speed) to force to apply
	
	physics cheatsheet:
		a = v/t
		f = am
		
		f = ma
		v = at
		a = dv/dt ; dv = a * dt
	
	--------- examples --------------
	
	-- right
	v = 2 ; s = 3	->	1
	v = 4 ; s = 3	->	0
	
	dif: s - v
	[3 - 2] 	1 (apply)
	[3 - 4] 	-1 (x < v)
	
	-- left
	v = -2 ; s = -3	-> -1	
	v = -4 ; s = -3	->	0
	
	dif: s - v
	[-3 - -2]	-1 (apply)
	[-3 - -4]	1 (x > v)
	
	-- right TO left
	v = 2 ; s = -3	->	-5
	v = 4 ; s = -3	->	-7
	
	dif: s - v
	[-3 - 2]	-5 (apply)
	[-3 - 4]	-7 (apply)
	
	-- left TO right
	v = -2 ; s = 3	->	5
	v = -4 ; s = 3	->	7
	
	dif: s - v
	[3 - -2]	5 (apply)
	[3 - -4]	7 (apply)
	
	equation:
		[dif] x = s - v
		if (s neg AND s > v) OR (s pos AND s < v)
			x = 0
		f = toForce(x)
		body->applyForce(f)
--]]

local function halt(self, dt)
	local m = self.body:getMass()
	local vx, _ = self.body:getLinearVelocity()
	local v = -vx + vx * self.deacceleration
	local a = v/dt
	local f = a*m
	self.body:applyForce(f, 0) 
end

return Entity

