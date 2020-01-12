local class = require "libs.cruxclass"
local Thing = require "template.Thing"
local IBoundingBox = require "behavior.IBoundingBox"
local Game = require "core.Game"
local Registry = require "istats.Registry"

local WorldObj = class("WorldObj", Thing):include(IBoundingBox)
function WorldObj:init(id, x, y, bodyType, angle)
	Thing.init(self, id)
	--TODO: Default to spr:getW/H/R() if no explicit w/h/r is provided.
	--TODO: Rename 'getShapeDat' to something more apropriate. Also, more abtract, to work with w/h, r, and/or others).		
	local a, b = Registry:getShapeDat(id)
	IBoundingBox.init(self, Game:getLoadedWorld(), x, y, 
		bodyType, Registry:getBodyDensity(id), Registry:getBodyMass(id),
		Registry:getBodyFriction(id), Registry:getBodyRestitution(id),
		Registry:getShapeType(id), a, b, angle)
	self:setFixedRotation(true)
	
end

return WorldObj