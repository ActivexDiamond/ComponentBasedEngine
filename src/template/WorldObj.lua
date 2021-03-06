local class = require "libs.cruxclass"
local Thing = require "template.Thing"
local IBoundingBox = require "behavior.IBoundingBox"

local Game = require "core.Game"
--local Registry = require "istats.Registry"

local EShapes = require "behavior.EShapes"

local WorldObj = class("WorldObj", Thing):include(IBoundingBox)
function WorldObj:init(id, x, y, bodyType, angle)
	Thing.init(self, id)
	--TODO: Default to spr:getW/H/R() if no explicit w/h/r is provided.
	--TODO: Rename 'getShapeDat' to something more appropriate. Also, more abstract, to work with w/h, r, and/or others).		
	local a, b = self:getShapeA(), self:getShapeB()
	IBoundingBox.init(self, Game:getLoadedWorld(), x, y, self,
		bodyType, self:getBodyDensity(), self:getBodyMass(),
		self:getBodyFriction(), self:getBodyRestitution(),
		self:getShapeType(), a, b, angle)
	self:setFixedRotation(true)
end

return WorldObj