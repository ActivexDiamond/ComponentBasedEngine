local class = require "libs.cruxclass"
local Game = require "core.Game"
local EShapes = require "template.EShapes"

---Private Methods
local function getShape(s, a, b, c)
	local p, e, f = love.physics, EShapes
	
	if s == e.RECT then f = p.newRectangleShape
	elseif s == e.CIRCLE then f = p.newCircleShape
	elseif s == e.POLY then f = p.newPolygonShape end
	-- TODO: add more shapes
	
	return f(a, b, c)
end

local function checkShapeDat(st, d)
	d = d:lower()
	if st == EShapes.RECT then
		return d == 'w' or d == 'h' or d == 'angle'
	elseif st == EShapes.CIRCLE then
		return d == 'r'
	end
	return false
end

local BoundingBox = class("Body")

--- @function [parent=#template.BoundingBox] init Construct a new BoundingBox.
-- @param #love.physics#World wThe world to create the body in.
-- @param #number x The x position of the bounding box (top left origin).
-- @param #number y The y position of the bounding box (top left origin).
-- @param #love.physics#BodyType type The type of the body; static, dynamic, or kinematic.
-- @param #template.EShapes shapeType The shape of the body (Rect, Circle, Poly, Precise, etc...).
-- @param #number a The first paramater to pass to the shape. Rect = w; Circle = r; Poly = vertices.
-- @param #number b The second paramater to pass to the shape. Rect = h;
-- @param #number c The third paramater to pass to the shape. Rect = angle; 

function BoundingBox:init(w, x, y, type, shapeType, a, b, c)
	self.shapeType = shapeType
	self.a, self.b, self.c = a, b, c
	self.b = love.physics.newBody(w, x, y, type)
	self.s = getShape(shapeType, a, b, c)
	self.f = love.physics.newFixture(self.b, self.s)
	
	f = love.physics.newBody();
	f = love.physics.newRectangleShape();
	f = love.physics.newCircleShape();
end

---Common position getters
function BoundingBox:getX() return self.b:getX() end
function BoundingBox:getY() return self.b:getY() end
function BoundingBox:getPos() return self.b:getX(), self.b:getY() end

---Rectangle data getters
function BoundingBox:getW()
	assert(checkShapeDat(self.shapeType, 'w'), "getW can only be called on rectangular BoundingBoxes.")
	return self.a
end

function BoundingBox:getH()
	assert(checkShapeDat(self.shapeType, 'h'), "getH can only be called on rectangular BoundingBoxes.")
	return self.b
end

function BoundingBox:getAngle()
	assert(checkShapeDat(self.shapeType, 'angle'), "getAngle can only be called on rectangular BoundingBoxes.")
	return self.c
end

function BoundingBox:getDims()
	assert(checkShapeDat(self.shapeType, 'w')
		and checkShapeDat(self.shapeType, 'h')
		and checkShapeDat(self.shapeType, 'angle'),"getDims can only be called on rectangular BoundingBoxes.")
	return self.a, self.b, self.c or 0
end

---Rectangle data setters
function BoundingBox:setW(w)
	assert(checkShapeDat(self.shapeType, 'w'), "getW can only be called on rectangular BoundingBoxes.")
	self.a = w
end

function BoundingBox:setH(h)
	assert(checkShapeDat(self.shapeType, 'h'), "getH can only be called on rectangular BoundingBoxes.")
	self.b = h
end

function BoundingBox:setAngle(a)
	assert(checkShapeDat(self.shapeType, 'angle'), "getAngle can only be called on rectangular BoundingBoxes.")
	self.c = a
end

function BoundingBox:setDims(w, h, a)
	assert(checkShapeDat(self.shapeType, 'w') 
		and checkShapeDat(self.shapeType, 'h'), "getDims can only be called on rectangular BoundingBoxes.")
	self.a, self.b, self.c = w, h, a
end

---Circle data getters
function BoundingBox:getRadius()
	assert(checkShapeDat(self.shapeType, 'r'), "getRadius can only be called on circular BoundingBoxes.")
	return self.a
end

function BoundingBox:getDiameter()
	return self:getRadius() * 2
end

---Object-common methods
function BoundingBox:clone()
	return BoundingBox(self.x, self.y, self.b:getType(), 
		self.shapeType, self.a, self.b, self.c)
end

return BoundingBox