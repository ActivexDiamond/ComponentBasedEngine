local Mixins = require "libs.Mixins"
local IBoundingBox = require "behavior.IBoundingBox"
local IHealth = require "behavior.IHealth"

local Scheduler = require "utils.Scheduler"
local Game = require "core.Game"

------------------------------ Upvalues ------------------------------

------------------------------ Helper Methods ------------------------------

------------------------------ Setup ------------------------------
local IHittable = Mixins("IHittable")
function IHittable:__postInit()
	assert(self:instanceof(IBoundingBox), "IMeleeAttack can only be applied on instances of IBoundingBox")
	assert(self:instanceof(IHealth), "IMeleeAttack can only be applied on instances of IHealth")
	self.invicCooldownMax = self.invicCooldownMax or 0.5
--	self.invicCooldown = self.invicCooldown or 0
	self.invic = false
end

------------------------------ Main Methods ------------------------------
function IHittable:getHit(attacker, dmg, knockback, effects)
	if self:_onPreHit(attacker, dmg, knockback, effects) then
		self:_onHit(attacker, dmg, knockback, effects)
		return self:_onPostHit(attacker, dmg, knockback, effects)
	end
	return false
end

------------------------------ Callbacks ------------------------------
function IHittable:_onPreHit(attacker, dmg, knockback, effects) return not self.invic end
function IHittable:_onHit(attacker, dmg, knockback, effects) 
	self.invic = true
	Scheduler:callAfter(self.invicCooldownMax, function() self.invic = false end)
	self:hurt(20)
	Scheduler:callFor(0.5, function()
		self.body:applyForce(300, -5)
	end)
	if DEBUG.LOG_COMBAT then
		print(self:getName() .. "  got attacked by  " .. attacker:getName())
	end
end
function IHittable:_onPostHit(attacker, dmg, knockback, effects) return true end
function IHittable:_onCancelledHit(attacker, dmg, knockback, effects) return false end

return IHittable

--[[
								TODO: rename "getHit"
getHit:		Public interface for getting attacked (TODO: rename)

onPreHit:	Mainly used to cancel the hit. If it returns false, the latter are ignored.
	Default: Cancels the hit if invincible, continues otherwise.
onHit:		The main effect/application of the hit. 
			Take dmg, knockback, effects, set invincibility, etc..
	Default: Sets invincibility flag (and frames/cooldown), 
		Takes dmg, knockback, and applies effects (respects armor).
onPostHit:	Mainly used to customize the value returned by the public API.
				(not called if the hit is cancelled)
	Default: Returns true.
	
onCancelledHit: Mainly used to customize the value returned by the public API.
				(called only if onPreHit returned false)
	Default: Returns false (default onPreHit only cancels if is invincible)
		
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

