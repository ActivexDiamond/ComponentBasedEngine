local class = require "libs.cruxclass"
local Mob = require "template.Mob"
local IHealth = require "behavior.IHealth"
local IMeleeAttack = require "behavior.IMeleeAttack"

local MeleeWeapon = require "template.MeleeWeapon"
local IBoundingBox = require "behavior.IBoundingBox"

local IEventHandler = require "evsys.IEventHandler"
local KeypressEvent = require "evsys.input.KeypressEvent"
local Keybinds  = require "core.Keybinds"

--local Game = require "core.Game"
--local Registry = require "istats.Registry"


------------------------------ Constructor ------------------------------ 
local Player = class("Player", Mob):include(IHealth, IEventHandler, IMeleeAttack)
function Player:init(x, y)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
	Mob.init(self, "player", x, y)
	self.weapon = MeleeWeapon("swordStone")
end


------------------------------ Main Methods ------------------------------
function Player:tick(dt)
	Mob.tick(self, dt)	
	local k = love.keyboard
	
	local dir = 0
	if k.isDown(Keybinds.LEFT) then dir = dir + Player.LEFT end
	if k.isDown(Keybinds.RIGHT) then dir = dir +  Player.RIGHT end
	local sprint = k.isDown(Keybinds.SPRINT)
	self:_walk(dir, sprint, dt)
end

function Player:draw(g)
	g.setColor(0, 0, 1, 1)
	g.polygon('fill', self.body:getWorldPoints(self.shape:getPoints()))
end	

------------------------------ @Callback ------------------------------
Player:attach(KeypressEvent, function(self, e)
	if e.k == Keybinds.JUMP then self:_jump() end
	
	if e.k == 'g' then self.totalJumps = self.totalJumps + 1 end
	if e.k == 'f' then self.extraJumps = self.extraJumps + 1 end
	if e.k == 'x' then self:attack(self.weapon) end
end)

return Player