local class = require "libs.cruxclass"
local Entity = require "template.Entity"
local IHealth = require "behavior.IHealth"

local IEventHandler = require "evsys.IEventHandler"
local KeypressEvent = require "evsys.input.KeypressEvent"
local Keybinds  = require "core.Keybinds"

local Game = require "core.Game"
--local Registry = require "istats.Registry"


local Player = class("Player", Entity):include(IEventHandler)

Player.LEFT = 1
Player.RIGHT = 2
function Player:init(x, y)
	Entity.init(self, "player", x, y)
	self.dir = Player.RIGHT	
	
	local b = self.body
	print('mass', b:getMass())
--	print('density', b:getMass())
--	print('friction', b:getMass())

	self.g = 0
	self.funcs = {}
	self.times = {}
	self.cleanup = {}
end
local move;
function Player:tick(dt)
	local k = love.keyboard

	if k.isDown(Keybinds.LEFT) then move(self, -self.speed, 0) end
	if k.isDown(Keybinds.RIGHT) then move(self, self.speed, 0) end
	
	
--	local maxVel = self.speed / self.bodyMass
--	local f =  
	
--	local vx, vy = self.body:getLinearVelocity()
--	local fx, fy = 0, 0
--	if k.isDown(Keybinds.LEFT) then 
--		fx = -self.speed * 1
--		self.dir = Player.LEFT
--	end
--	if k.isDown(Keybinds.RIGHT) then 
--		fx = self.speed * 1
--		self.dir = Player.RIGHT
--	end
--	self.body:applyLinearImpulse(fx, fy)
	
	self:updateFuncs(dt)
end

function Player:jump()
--	local vx, vy = self.body:getLinearVelocity()
--	vy = vy - self.jumpHeight
--	self.body:setLinearVelocity(vx, vy)
	self.body:applyLinearImpulse(0, -self.jumpHeight * 7.5)
end

function Player:callFor(s, f, c)
	local i = false;
	for k, v in ipairs(self.funcs) do
		if v == f then i = k end
	end
	if not i then 
		table.insert(self.funcs, f)
		table.insert(self.times, s)
		table.insert(self.cleanup, c or function() end)
	end
end

function Player:updateFuncs(dt)
	if #self.funcs > 0 then
		for k, f in ipairs(self.funcs) do
			self.times[k] = self.times[k] - dt
			if self.times[k] <= 0 then 
				self.cleanup[k]()
				table.remove(self.funcs, k)
				table.remove(self.times, k)
				table.remove(self.cleanup, k)
			else f() end
		end
	end
end

local function reqF(s, v)
	local x = s - v;	local dt, m = 1/60, 1
	if (0 > s and s > v) or (0 < s and s < v) then x = 0 end
	local a = x/dt
	local f = a*m
	return f
end

function move(obj, sx, sy)
	local vx, vy = obj.body:getLinearVelocity()
	local fx, fy = reqF(sx, vx), 0--reqF(sy, vy)
	local str = string.format('about to apply force of: %.3f\t\t%.f', fx, fy)
	print(str)
	print('\t --- \t', 'sx', sx, 'vx', vx)
	obj.body:applyForce(fx, fy)
--	obj.body:setLinearVelocity(sx, sy)
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

local function halt(self)
	local vx, vy = self.body:getLinearVelocity()
	vx, vy = 0, 0
	self.body:setLinearVelocity(vx, vy)
end

---@Callback
Player:attach(KeypressEvent, function(self, e)
--	if e.k == Keybinds.JUMP then
--		self:jump()
--	end

	if e.k == 'v' then
		local vx, vy = self.body:getLinearVelocity()
		vy = -10
		self.body:setLinearVelocity(vx, vy)
	end
	
	if e.k == 'f' then
		self.body:applyForce(0, -300)	
	end
	
	if e.k == 't' then
		self:callFor(0.1, function()
			self.body:applyForce(0, -100)
		end)	
	end
	
	if e.k == 'i' then
		self.body:applyLinearImpulse(0, -10)
	end
	
	if e.k == 'left' then
		self:callFor(3, function()
			move(self, -self.speed, 0)
		end, function()
			halt(self)
		end)	
--		move(self, -self.speed, 0)
	end
		
	if e.k == 'right' then
		self:callFor(3, function()
			move(self, self.speed, 0)
		end, function()
			halt(self)
		end)		
	end
	
	if e.k == 'g' then
		self:callFor(3, function()
			self.g = self.g + 1
		end, function()
			self.g = 0
		end)
	end
end)

return Player