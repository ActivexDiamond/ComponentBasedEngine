local Mixins = require "libs.Mixins"
local IBoundingBox = require "IBoundingBox"
local MeleeWeapon = require "template.MeleeWeapon"

local Scheduler = "utils.Scheduler"
------------------------------ Setup ------------------------------
local IMeleeAttack = {}
Mixins.onPostInit(IMeleeAttack, function(self)
	assert(self:instanceof(IBoundingBox), "IMeleeAttack can only be applied on instances of IBoundingBox")
end)

------------------------------ Coordinate Aligners ------------------------------
local function alignCoords(self, anchor, area)
	
end

local function alignOrigin()

end

local function alignCenter()

end

local function alignNatural()

end

------------------------------ Transition Runners ------------------------------
local function transInstant(dt, self, prevArea, phase)
	local area = alignCoords(self, phase.anchor, phase.area)
	
end

local function transLinearGrow(dt, self, prevArea, phase)
	local area = alignCoords(self, phase.anchor, phase.area)
	
end

------------------------------ Main Methods ------------------------------
---Called when a hittable mob is hit.
local function onHit()

end

---Passed to Box2D as callback; filters collision to hittable mobs only.
local function onCollision()
	
end
	
---Fetches the vars for the phase, schedules it, and chains the next phase.
local function schedulePhase(self, wpn, i)	
	local bx, prevArea = wpn.hitbox
	if i == 1 then prevArea = alignCoords(self, bx.startAnchor, bx.start)
	else prevArea = alignCoords(self, bx[i - 1].anchor, bx[i - 1].area) end
	
	
	local phase = bx[i]
	local dur = phase.dur
	local freq = phase.freq or -1
	local trans = phase.transition
	
	local checker; 
	if trans == MeleeWeapon.transitions.INSTANT then checker = transInstant
	elseif trans == MeleeWeapon.transitions.LINEAR_GROW then checker = transLinearGrow end
	
	Scheduler:callEveryFor(freq, dur, checker, {self, wpn, prevArea, phase},
			schedulePhase, {self, wpn, i + 1})
end

function IMeleeAttack:attack(wpn)
	schedulePhase(self, wpn, 1)
end

return IMeleeAttack

