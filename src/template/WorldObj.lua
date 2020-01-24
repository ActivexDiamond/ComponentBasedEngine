local class = require "libs.cruxclass"
local Thing = require "template.Thing"
local IBoundingBox = require "behavior.IBoundingBox"

local Game = require "core.Game"
local Registry = require "istats.Registry"

local EShapes = require "behavior.EShapes"

local WorldObj = class("WorldObj", Thing):include(IBoundingBox)
function WorldObj:init(id, x, y, bodyType, angle)
	Thing.init(self, id)
	--TODO: Default to spr:getW/H/R() if no explicit w/h/r is provided.
	--TODO: Rename 'getShapeDat' to something more appropriate. Also, more abstract, to work with w/h, r, and/or others).		
	local a, b = Registry:getShapeDat(id)
	IBoundingBox.init(self, Game:getLoadedWorld(), x, y, self,
		bodyType, Registry:getBodyDensity(id), Registry:getBodyMass(id),
		Registry:getBodyFriction(id), Registry:getBodyRestitution(id),
		Registry:getShapeType(id), a, b, angle)
	self:setFixedRotation(true)
	
	self:setCategory(IBoundingBox.categories.WORLD_OBJ)
	self:setMask(IBoundingBox.categories.WORLD_OBJ)
end

return WorldObj