local Mixins = require "libs.Mixins"
local IBoundingBox = require "behavior.IBoundingBox"
local IHealth = require "behavior.IHealth"

local Scheduler = require "utils.Scheduler"
local Game = require "core.Game"

------------------------------ Upvalues ------------------------------

------------------------------ Helper Methods ------------------------------

------------------------------ Setup ------------------------------
local IHittable = Mixins("IHittable")
Mixins.onPostInit(IHittable, function(self)
	assert(self:instanceof(IBoundingBox), "IMeleeAttack can only be applied on instances of IBoundingBox")
	assert(self:instanceof(IHealth), "IMeleeAttack can only be applied on instances of IHealth")
	self.invicCooldownMax = self.invicCooldownMax or 0.5
--	self.invicCooldown = self.invicCooldown or 0
	self.invic = false
end)

------------------------------ Main Methods ------------------------------
function IHittable:getHit(attacker, dmg, knockback, effects)
	if self.invic then return false end
	self.invic = true
	Scheduler:callAfter(self.invicCooldownMax, function() self.invic = false end)
	
	print(self:getName() .. "  got attacked by  " .. attacker:getName())
	self:hurt(20)
	
	Scheduler:callFor(0.5, function()
		self.body:applyForce(300, -5)
	end)
	
	
end

return IHittable

--[[
Terminology:
attack -> melee attack
shoot -> ranged attacked
throw -> projectile toss (similar to above)

hit -> general; melee or ranged

onX -> passed as callback
? prefix for evsys event callbacks ?
verb -> do action (e.g. attack)
getVerb -> be object of action (e.g. getHit)
--]]

