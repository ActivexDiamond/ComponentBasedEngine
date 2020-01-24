local Mixins = require "libs.Mixins"
local IBoundingBox = require "behavior.IBoundingBox"
local WeaponDef = require "template.WeaponDef"

local Scheduler = require "utils.Scheduler"
local Game = require "core.Game"

------------------------------ Upvalues ------------------------------
local onCollision;

------------------------------ Helper Methods ------------------------------
local function lerp(t, a, b)
	return a * (1 - t) + b * t
end

local function lerpArea(t, a, b)
	local x, y, w, h;
	x = lerp(t, a[1], b[1])
	y = lerp(t, a[2], b[2])
	w = lerp(t, a[3], b[3])
	h = lerp(t, a[4], b[4])
	return {x, y, w, h}
end

--TODO: refactor into the abstraction layer for Box2D.
local function box2dWrapper(func, ...)
	local args = {...}
	return function(fixt) func(fixt, unpack(args)) end
end

------------------------------ Setup ------------------------------
local IMeleeAttack = {}
Mixins.onPostInit(IMeleeAttack, function(self)
	assert(self:instanceof(IBoundingBox), "IMeleeAttack can only be applied on instances of IBoundingBox")
end)

------------------------------ Coordinate Aligners ------------------------------
local function alignOrigin(ox, oy, ow, oh, x, y, w, h)
	return {ox + x, oy + y, w, h}
end

local function alignCenter(ox, oy, ow, oh, x, y, w, h)
	return {ox + (ow/2) + x, oy + (oh/2) + y, w, h}
end

local function alignNatural(ox, oy, ow, oh, x, y, w, h)
	return {ox + (ow/2) + x, oy + (oh/2) + y - (h/2), w, h}
end

local function alignCoords(self, anchor, area)
	local ox, oy = self:getPos()
	local ow, oh = self:getDims()
	if anchor == WeaponDef.anchors.ORIGIN then return alignOrigin(ox, oy, ow, oh, unpack(area))
	elseif anchor == WeaponDef.anchors.CENTER then return alignCenter(ox, oy, ow, oh, unpack(area))
	elseif anchor == WeaponDef.anchors.NATURAL then return alignNatural(ox, oy, ow, oh, unpack(area)) end
end

------------------------------ Transition Runners ------------------------------
local function checkCollision(self, bb, wpn)
	Game.world:queryBoundingBox(bb[1], bb[2], bb[3], bb[4], 
			box2dWrapper(onCollision, self, wpn))
			
	if DEBUG.BOUNDING_BOXES then
		local g = love.graphics
		g.setColor(1, 1, 1, 1)
		g.rectangle('fill', unpack(bb))
	end
end

local function transInstant(dt, per, self, wpn, prevAnchor, prevArea, anchor, area, dur, freq)
	prevArea = alignCoords(self, prevAnchor, prevArea)
	area = alignCoords(self, anchor, area)
	local bb = area
	
	checkCollision(self, bb, wpn)
end

local function transLinearGrow(dt, per, self, wpn, prevAnchor, prevArea, anchor, area, dur, freq)
	prevArea = alignCoords(self, prevAnchor, prevArea)
	area = alignCoords(self, anchor, area)
	local bb = lerpArea(per, prevArea, area)
	
	checkCollision(self, bb, wpn)
end

------------------------------ Main Methods ------------------------------
---Called when a hittable mob is hit.
local function onHit()

end

---Passed to Box2D as callback; filters collision to hittable mobs only.
local function onCollision(self, fixt,  wpn)
	
end
	
local function onAttackDone(self, wpn)
	print('done')
end
---Fetches the vars for the phase, schedules it, and chains the next phase.
local function schedulePhase(self, wpn, i)	
	local bx, prevAnchor, prevArea = wpn.hitbox
	if i == 1 then prevAnchor, prevArea = bx.startAnchor, bx.start
	else prevAnchor, prevArea = bx[i - 1].anchor, bx[i - 1].area end

	local phase = bx[i]
	local anchor = phase.anchor
	local area = phase.area
	local dur = phase.dur
	local freq = phase.freq or -1
	local trans = phase.transition or WeaponDef.transitions.LINEAR_GROW
	
	local checker; 
	if trans == WeaponDef.transitions.INSTANT then checker = transInstant
	elseif trans == WeaponDef.transitions.LINEAR_GROW then checker = transLinearGrow end

	local chain;
	if i < #bx then chain = schedulePhase
	else chain = onAttackDone end
	
	Scheduler:gCallEveryFor(freq, dur, checker, {self, wpn, prevAnchor, prevArea, anchor, area, dur, freq},
			chain, {self, wpn, i + 1})
			
--	print('-------------')
--	print('i', i, 'freq', freq, 'dur', dur, 'trans', trans)
--	print('prevAnchor', prevAnchor, 'prevArea', unpack(prevArea))
--	print('anchor', anchor, 'area', unpack(area))
--	print('-------------')
end

function IMeleeAttack:attack(wpn)
	schedulePhase(self, wpn, 1)
end

return IMeleeAttack

