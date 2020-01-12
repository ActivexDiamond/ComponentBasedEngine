local class = require "libs.cruxclass"
local Thing = require "template.Thing"
local IBoundingBox = require "behavior.IBoundingBox"

local WorldObj = class("WorldObj", Thing):include(IBoundingBox)
function WorldObj:init(id, x, y)
	Thing.init(self, id)
	
	
	
	self.x, self.y = x, y
	self.bb = Rectangle(x, y) --TODO: w/h
end

--- @param #WorldObj o -- a WorldObj, or table of them.
function WorldObj:intersects(o) error("Abstract method not overriden.") end   -- o/false

function WorldObj:getX() return  self.bb:getX() end
function WorldObj:getY() return  self.bb:getY() end
function WorldObj:getW() return self.bb:getW() end
function WorldObj:getH() return self.bb:getH() end

function WorldObj:getCoords() return self.bb:getCoords() end	
function WorldObj:getSize() return  self.bb:getSize() end
function WorldObj:getBounds() return  self.bb:getBounds() end
function WorldObj:getBoundingBox() return self.bb end
function WorldObj:cloneBoundingBox() return  self.bb:clone() end

function WorldObj:setX(x) self.bb:setX(x) end
function WorldObj:setY(y) self.bb:setY(y) end
function WorldObj:setCoords(a, b)
	if type(a) == 'table' and a.instanceof and a.instanceof(Vector) then
		self.bb:setCoords(a[1], a[2])
	else self.bb:setCoords(a, b) end
end

return WorldObj