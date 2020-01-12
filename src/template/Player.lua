local class = require "libs.cruxclass"
local Mob = require "template.Mob"
local IHealth = require "behavior.IHealth"

local IEventHandler = require "evsys.IEventHandler"
local KeypressEvent = require "evsys.input.KeypressEvent"
local Keybinds  = require "core.Keybinds"

local Game = require "core.Game"
--local Registry = require "istats.Registry"


------------------------------ Constructor ------------------------------ 
local Player = class("Player", Mob):include(IEventHandler)
function Player:init(x, y)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
	Mob.init(self, "player", x, y)
	self.state = MultiState()
	self.dir = Player.RIGHT	
	self.jumpsRemaining = self.totalJumps
	self.extraJumps = 0
end


------------------------------ Main Methods ------------------------------
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

------------------------------ Movement ------------------------------
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

------------------------------ @Callback ------------------------------
Player:attach(KeypressEvent, function(self, e)
	if e.k == Keybinds.JUMP then self:_jump() end
	
	if e.k == 'g' then self.totalJumps = self.totalJumps + 1 end
	if e.k == 'f' then self.extraJumps = self.extraJumps + 1 end
end)

return Player