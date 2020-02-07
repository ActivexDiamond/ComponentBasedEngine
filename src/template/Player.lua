local class = require "libs.cruxclass"
local Mob = require "template.Mob"
local IHealth = require "behavior.IHealth"
local IMeleeAttack = require "behavior.IMeleeAttack"

local MeleeWeapon = require "template.MeleeWeapon"
local IBoundingBox = require "behavior.IBoundingBox"

local Item = require "template.Item"
local ItemStack = require "inv.ItemStack"
local Slot = require "inv.Slot"
local Inventory = require "inv.Inventory"

local IEventHandler = require "evsys.IEventHandler"
local KeypressEvent = require "evsys.input.KeypressEvent"
local Keybinds  = require "core.Keybinds"

local Game = require "core.Game"
--local Registry = require "istats.Registry"


------------------------------ Constructor ------------------------------ 
local Player = class("Player", Mob):include(IHealth, IEventHandler, IMeleeAttack)
function Player:init(x, y)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
	Mob.init(self, "player", x, y)
	self.weapon = MeleeWeapon("stone|sword")
	--TODO: Proper player inv / mouseSlot.
--	self.mouseInv = Inventory{slots = Slot{itemStack = ItemStack(Item("coal|oredrop"), 64),
--			noBg = true, noHit = true}}
	local coalStack = ItemStack(Item("coal|oredrop"), 48)
	local mouseInv = Inventory{slots = Slot{--itemStack = coalStack,
			noBg = true, noHit = true}}
	mouseInv:setPos(30, 30)
	self.mouseInv = mouseInv
	
	Game.player = self
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
	
	--TODO: Proper player inv / mouseSlot.
	local s = Game.graphics.GUI_SCALE
	self.mouseInv:setPos(love.mouse.getX()/s, love.mouse.getY()/s)
	self.mouseInv:tickGui()
end

function Player:draw(g)
	g.setColor(0, 0, 1, 1)
	g.polygon('fill', self.body:getWorldPoints(self.shape:getPoints()))
end	

function Player:drawGui()
--	TODO: Proper player inv / mouseSlot.
	self.mouseInv:drawGui()
end	

------------------------------ @Callback ------------------------------
Player:attach(KeypressEvent, function(self, e)
	if e.k == Keybinds.JUMP then self:_jump() end
	
	if e.k == 'g' then self.totalJumps = self.totalJumps + 1 end
	if e.k == 'f' then self.extraJumps = self.extraJumps + 1 end
	if e.k == 'x' then self:attack(self.weapon) end
end)

------------------------------ Getters / Setters ------------------------------
function Player:getMouseInv() return self.mouseInv end
function Player:getMouseSlot() return self.mouseInv:getChild(1) end
return Player