local class = require "libs.cruxclass"
local Entity = require "template.Entity"
local IHealth = require "behavior.IHealth"
local MultiState = require "core.MultiState"

local IEventHandler = require "evsys.IEventHandler"
local KeypressEvent = require "evsys.input.KeypressEvent"
local Keybinds  = require "core.Keybinds"

local Game = require "core.Game"
--local Registry = require "istats.Registry"

---Helper Methods
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

---Constructor
local Player = class("Player", Entity):include(IEventHandler)
function Player:init(x, y)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
	Entity.init(self, "player", x, y)
	self.state = MultiState()
	self.dir = Player.RIGHT	
	self.jumpsRemaining = self.totalJumps
	self.extraJumps = 0
end

---Constants
Player.LEFT = -1
Player.RIGHT = 1

Player.MOTIONLESS, Player.MOVING,
Player.CRAWLING, Player.WALKING, 
Player.AIRBORNE, Player.JUMPING, 
Player.FLYING, Player.CLIMBING = MultiState:create()


---Main Methods
function Player:tick(dt)
	local k = love.keyboard
	local vx, vy = self.body:getLinearVelocity()
	
	---If player collides with a ceiling while jumping, vy
	--will equal 0 for one tick; relay on Jumping as a form
	--of 'previous_vy' to differntiate that from landing.
	local jumping = self.state:is(Player.JUMPING)
	local air = vy ~= 0 or jumping 
	---If airborne state changed:
	if self.state:set(Player.AIRBORNE, air) then
		--From true to false; aka just landed: recharge
		if not air then self.jumpsRemaining = self.totalJumps end
		--From false to true and NOT jumping; aka slipped: lose 1 jump
		if air and not jumping then self.jumpsRemaining = self.jumpsRemaining - 1 end
	end
	if vy > 0 then self.state:unset(Player.JUMPING) end
	
	---If moving at all:
	if vx == 0 then self.state:set(Player.MOTIONLESS)
	else self.state:set(Player.MOVING) end
	
	---If actively walking:
	local d = 0
	if k.isDown(Keybinds.LEFT) then d = d + Player.LEFT end
	if k.isDown(Keybinds.RIGHT) then d = d + Player.RIGHT end
	if d ~= 0 then
		self.dir = d
		self.state:set(Player.WALKING)
		move(self, self.speed * d, nil, dt)
	else 
		if self.state:isnot(Player.AIRBORNE) then halt(self, dt) end
		self.state:unset(Player.WALKING) 
	end 
end

---Movement
function Player:_setJumpingVelocity()
	local vx, vy = self.body:getLinearVelocity()
	vy = self.jumpHeight * -7.5 --TODO: Use proper equation/curve.
	self.body:setLinearVelocity(vx, vy)
end

function Player:_jump()
	if self.jumpsRemaining == 0 and self.extraJumps > 0 then
		self.jumpsRemaining = self.jumpsRemaining + 1
		self.extraJumps = self.extraJumps - 1
	end
	if self.jumpsRemaining > 0 then
		self.jumpsRemaining = self.jumpsRemaining - 1
		self.state:set(Player.JUMPING)
		self:_setJumpingVelocity()
	end
end


---@Callback
Player:attach(KeypressEvent, function(self, e)
	if e.k == Keybinds.JUMP then self:_jump() end
	
	if e.k == 'g' then self.totalJumps = self.totalJumps + 1 end
	if e.k == 'f' then self.extraJumps = self.extraJumps + 1 end
end)

return Player