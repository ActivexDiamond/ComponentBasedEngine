local Mixins = require "libs.Mixins"
local EShapes = require "behavior.EShapes"

---Private Methods
local function getShape(s, a, b, c)
	local p, e, f = love.physics, EShapes
	
	if s == e.RECT then f = p.newRectangleShape
	elseif s == e.CIRCLE then f = p.newCircleShape
	elseif s == e.POLY then f = p.newPolygonShape end
	--TODO: add more shapes
	
	--if b ~= nil, then offset at a/2, b/2 (rect),
	--otherwise offset by a/2, a/2 (circle)
	return f(a / 2, (b and b / 2 or a), a, b, c)
--	return f(0, 0, a, b, c)
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

---Constructor
local IBoundingBox = {}
--- @function [parent=#behavior.IBoundingBox] init Construct a new BoundingBox.
-- @param #object self An object of the class IBoundingBox was included on.
-- @param #love.physics#World world The world to create the body in.
-- @param #number x The x position of the bounding box (top left origin).
-- @param #number y The y position of the bounding box (top left origin).
-- @param #luaValue userData The value to assign to user data, if any.
-- @param #love.physics#BodyType bodyType The type of the body; static, dynamic, or kinematic.
-- @param #number bodyDensity Set the density of the body. If nil, uses Box2D's internal default density.
-- @param #number bodyMass Set the mass of the body directly, ignoring size AND density. If nil, uses Box2D's internal mass computation.
-- @param #number bodyFriction Set the friction of the body. If nil, uses Box2D's internal default friction.
-- @param #number bodyRestitution Set the restitution of the body. If nil, uses Box2D's internal default restitution.
-- @param #template.EShapes shapeType The shape of the body (Rect, Circle, Poly, Precise, etc...).
-- @param #number a The first parameter to pass to the shape. Rect = w; Circle = r; Poly = vertices.
-- @param #number b The second parameter to pass to the shape. Rect = h;
-- @param #number c The third parameter to pass to the shape. Rect = angle; 
function IBoundingBox:init(world, x, y, userData,
			bodyType, bodyDensity, bodyMass, 
			bodyFriction, bodyRestitution, 
			shapeType, a, b, c)
	self.shapeType = shapeType
	self.baseBodyDensity = bodyDensity
	self.baseBodyFriction = bodyFriction
	self.baseBodyRestitution = bodyRestitution
	self.baseBodyMass = bodyMass
	self.a, self.b, self.c = a, b, c
	self.body = love.physics.newBody(world, x, y, bodyType)
	self.shape = getShape(shapeType, a, b, c)
	self.fixture = love.physics.newFixture(self.body, self.shape)
	
	if bodyDensity then self.fixture:setDensity(bodyDensity) end
	if bodyFriction then self.fixture:setFriction(bodyFriction) end
	if bodyRestitution then self.fixture:setRestitution(bodyRestitution) end
	if bodyMass then
		local x, y, m, i = self.body:getMassData()
		self.body:setMassData(x, y, bodyMass, i * bodyMass / m)
	end	
	if userData then self.fixture:setUserData(userData) end
end

---Common position getters
function IBoundingBox:getX() return self.body:getX() end
function IBoundingBox:getY() return self.body:getY() end
function IBoundingBox:getPos() return self.body:getX(), self.body:getY() end

---Common position setters
function IBoundingBox:setX(x) self.body:setX(x) end
function IBoundingBox:setY(y) self.body:setY(y) end
function IBoundingBox:setPos(x, y) self:setX(x); self:setY(y) end

---Body data getters
function IBoundingBox:isFixedRotation()
	return self.body:isFixedRotation()
end
---Body data setters
function IBoundingBox:setFixedRotation(r)
	local x, y, m, i = self.body:getMassData()
	self.body:setFixedRotation(r)
	local curM = self.body:getMass()
	self.body:setMassData(x, y, m, i * m / curM)
end

---Rectangle data getters
function IBoundingBox:getW()
	print(self.shapeType)
	assert(checkShapeDat(self.shapeType, 'w'), "getW can only be called on rectangular BoundingBoxes.")
	return self.a
end

function IBoundingBox:getH()
	assert(checkShapeDat(self.shapeType, 'h'), "getH can only be called on rectangular BoundingBoxes.")
	return self.b
end

function IBoundingBox:getAngle()
	error "WIP"
	assert(checkShapeDat(self.shapeType, 'angle'), "getAngle can only be called on rectangular BoundingBoxes.")
	return self.c
end

function IBoundingBox:getDims()
	assert(checkShapeDat(self.shapeType, 'w')
		and checkShapeDat(self.shapeType, 'h'), "getDims can only be called on rectangular BoundingBoxes.")
--		and checkShapeDat(self.shapeType, 'angle'),"getDims can only be called on rectangular BoundingBoxes.")
	return self.a, self.b --, self.c or 0
end

---Rectangle data setters
function IBoundingBox:setW(w)
	assert(checkShapeDat(self.shapeType, 'w'), "getW can only be called on rectangular BoundingBoxes.")
	self.a = w; self:reshape()
end

function IBoundingBox:setH(h)
	assert(checkShapeDat(self.shapeType, 'h'), "getH can only be called on rectangular BoundingBoxes.")
	self.b = h; self:reshape()
end

function IBoundingBox:setAngle(a)
	assert(checkShapeDat(self.shapeType, 'angle'), "getAngle can only be called on rectangular BoundingBoxes.")
	self.c = a; self:reshape()
end

function IBoundingBox:setDims(w, h, a)
	assert(checkShapeDat(self.shapeType, 'w') 
		and checkShapeDat(self.shapeType, 'h'), "getDims can only be called on rectangular BoundingBoxes.")
	self.a, self.b, self.c = w, h, a; self:reshape()
end

---Circle data getters
function IBoundingBox:getRadius()
	assert(checkShapeDat(self.shapeType, 'r'), "getRadius can only be called on circular BoundingBoxes.")
	return self.a
end

function IBoundingBox:getDiameter()
	return self:getRadius() * 2
end

---Circle data setters
function IBoundingBox:setRadius(r)
	assert(checkShapeDat(self.shapeType, 'r'), "getRadius can only be called on circular BoundingBoxes.")
	self.a = r; self:reshape()
end

---Helper methods
function IBoundingBox:_reshape()
	--TODO: Test; see if fixture requires refreshing too.
	self.s = getShape(self.shapeType, self.a, self.b, self.c)
end

---Object-common methods
function IBoundingBox:clone()
	return IBoundingBox(self.x, self.y, self.body:getType(), 
		self.shapeType, self.a, self.b, self.c)
end

return IBoundingBox
