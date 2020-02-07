local Mixins = require "libs.Mixins"

------------------------------ Private Methods ------------------------------
local function getShape(self, s, a, b, c)
	local p, f = love.physics
	
	if s == self.RECT then f = p.newRectangleShape
	elseif s == self.CIRCLE then f = p.newCircleShape
	elseif s == self.POLY then f = p.newPolygonShape end
	--TODO: add more shapes
	
	--if b ~= nil, then offset at a/2, b/2 (rect),
	--otherwise offset by a/2, a/2 (circle)
	return f(a / 2, (b and b / 2 or a), a, b, c)
--	return f(0, 0, a, b, c)
end

local function checkShapeDat(self, d)
	local st = self.shapeType
	d = d:lower()
	if st == self.RECT then
		return d == 'w' or d == 'h' or d == 'angle'
	elseif st == self.CIRCLE then
		return d == 'r'
	end
	return false
end

------------------------------ Constructor ------------------------------
local IBoundingBox = Mixins("IBoundingBox")
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
	self.shape = getShape(self, shapeType, a, b, c)
	self.fixture = love.physics.newFixture(self.body, self.shape)
	
	if bodyDensity then self.fixture:setDensity(bodyDensity) end
	if bodyFriction then self.fixture:setFriction(bodyFriction) end
	if bodyRestitution then self.fixture:setRestitution(bodyRestitution) end
	if bodyMass then
		local x, y, m, i = self.body:getMassData()
		self.body:setMassData(x, y, bodyMass, i * bodyMass / m)
	end	
	if userData then self.fixture:setUserData(userData) end
	
	if DEBUG.MASKS then
		local c = utils.toBin(self:getCategory(), 16, 4) 
		local m = utils.toBin(self:getMask(), 16, 4)
		local str = "%s\tcategory:%s\tmask:%s"
		local name = tostring(self)
		if name:len() < 40 then
			for i = 1, 40 - name:len() do
				name = name .. ' '
			end
		end
		print(str:format(name, c, m))
	end
	self:setCategory(self:getCategory())
	self:setMask(self:getMask())
end
------------------------------ Constants ------------------------------
IBoundingBox.RECT = 0
IBoundingBox.CIRCLE = 1
IBoundingBox.POLY = 2

------------------------------ Categories (Endpoints) ------------------------------
IBoundingBox.masks = {}
local m = IBoundingBox.masks

--Nibble 1
m.BLOCK,
m.FREE,
m.FREE,
m.FREE,

--Nibble 2; Misc. Entities
m.ITEM_DROP,
m.FREE,
m.FREE,
m.FREE,

--Nibble 3; Mobs
m.HOSTILE_MOB,
m.NEUTRAL_MOB,
m.PASSIVE_MOB,
m.PLAYER,

--Nibble 4; Projectiles
m.NPC_PRJ,
m.PLAYER_PRJ,
m.FREE,
m.MP		--TODO: Should an instance being created with m.MP emit an error or be allowed?

--2^0 through 2^15 (16bits)
	= 1, 2, 4, 8, 16, 32, 64, 128, 256, 516, 1024, 2048, 4096, 8192, 16384, 32768
--[[
Hierarchy:
Solid ->
	Block |E|
	
	Entity ->
		ItemDrop |E|
		Projectile ->
			PlayerPrj |E|
			NpcPrj |E|
		Mob ->
			Player |E|
			Npc ->
				Hostile |E|
				Neutral |E|
				Passive |E|
		
Powers:
	1   2   4   8      16   32   64   128      256   512   1024   2048      4096   8192   16384   32768
	1   2   4   8      10   20   40   80       100   200   400    800       1000   2000   4000    8000 
--]]

------------------------------ Masks ------------------------------
m.NPC = m.HOSTILE_MOB + m.NEUTRAL_MOB + m.PASSIVE_MOB
m.MOB = m.NPC + m.PLAYER
	
m.PRJ = m.NPC_PRJ + m.PLAYER_PRJ

m.ENTITY = m.PRJ + m.MOB + m.ITEM_DROP

m.SOLID = m.ENTITY + m.BLOCK

------------------------------ Category/Mask Methods ------------------------------
function IBoundingBox:setCategory(c)	
	local _, mask, group = self.fixture:getFilterData()
	self.fixture:setFilterData(c, mask, group)
end
function IBoundingBox:addCategory(c)	--TODO: check if category is already assigned.
	local cat, mask, group = self.fixture:getFilterData()
	self.fixture:setFilterData(cat + c, mask, group)
end
function IBoundingBox:removeCategory(c)	
	local cat, mask, group = self.fixture:getFilterData()
	self.fixture:setFilterData(cat - c, mask, group)
end

function IBoundingBox:setMask(m)	
	local cat, _, group = self.fixture:getFilterData()
	self.fixture:setFilterData(cat, m, group)
end
function IBoundingBox:addMask(m)	
	local cat, mask, group = self.fixture:getFilterData()
	self.fixture:setFilterData(cat, mask + m, group)
end
function IBoundingBox:removeMask(m)	
	local cat, mask, group = self.fixture:getFilterData()
	self.fixture:setFilterData(cat, mask - m, group)
end

------------------------------ Common Position Getters ------------------------------
function IBoundingBox:getX() return self.body:getX() end
function IBoundingBox:getY() return self.body:getY() end
function IBoundingBox:getPos() return self.body:getX(), self.body:getY() end

------------------------------ Common Position Setters ------------------------------
function IBoundingBox:setX(x) self.body:setX(x) end
function IBoundingBox:setY(y) self.body:setY(y) end
function IBoundingBox:setPos(x, y) self:setX(x); self:setY(y) end

------------------------------ Body Data Getters ------------------------------
function IBoundingBox:isFixedRotation()
	return self.body:isFixedRotation()
end

------------------------------ Body Data Setters ------------------------------
function IBoundingBox:setFixedRotation(r)
	local x, y, m, i = self.body:getMassData()
	self.body:setFixedRotation(r)
	local curM = self.body:getMass()
	self.body:setMassData(x, y, m, i * m / curM)
end

------------------------------ Rectangle Data Getters ------------------------------
function IBoundingBox:getW()
	assert(checkShapeDat(self, 'w'), "getW can only be called on rectangular BoundingBoxes.")
	return self.a
end

function IBoundingBox:getH()
	assert(checkShapeDat(self, 'h'), "getH can only be called on rectangular BoundingBoxes.")
	return self.b
end

function IBoundingBox:getAngle()
	error "WIP"
	assert(checkShapeDat(self, 'angle'), "getAngle can only be called on rectangular BoundingBoxes.")
	return self.c
end

function IBoundingBox:getDims()
	assert(checkShapeDat(self, 'w')
		and checkShapeDat(self, 'h'), "getDims can only be called on rectangular BoundingBoxes.")
--		and checkShapeDat(self.shapeType, 'angle'),"getDims can only be called on rectangular BoundingBoxes.")
	return self.a, self.b --, self.c or 0
end

------------------------------ Rectangle Data Setters ------------------------------
function IBoundingBox:setW(w)
	assert(checkShapeDat(self, 'w'), "getW can only be called on rectangular BoundingBoxes.")
	self.a = w; self:reshape()
end

function IBoundingBox:setH(h)
	assert(checkShapeDat(self, 'h'), "getH can only be called on rectangular BoundingBoxes.")
	self.b = h; self:reshape()
end

function IBoundingBox:setAngle(a)
	assert(checkShapeDat(self, 'angle'), "getAngle can only be called on rectangular BoundingBoxes.")
	self.c = a; self:reshape()
end

function IBoundingBox:setDims(w, h, a)
	assert(checkShapeDat(self, 'w') 
		and checkShapeDat(self, 'h'), "getDims can only be called on rectangular BoundingBoxes.")
	self.a, self.b, self.c = w, h, a; self:reshape()
end

------------------------------ Circle Data Getters ------------------------------
function IBoundingBox:getRadius()
	assert(checkShapeDat(self, 'r'), "getRadius can only be called on circular BoundingBoxes.")
	return self.a
end

function IBoundingBox:getDiameter()
	return self:getRadius() * 2
end

------------------------------ Circle Data Setters ------------------------------
function IBoundingBox:setRadius(r)
	assert(checkShapeDat(self, self, 'r'), "getRadius can only be called on circular BoundingBoxes.")
	self.a = r; self:reshape()
end

------------------------------ Helper Methods ------------------------------
function IBoundingBox:_reshape()
	--TODO: Test; see if fixture requires refreshing too.
	self.s = getShape(self, self.shapeType, self.a, self.b, self.c)
end

------------------------------ Object-common Methods ------------------------------
function IBoundingBox:clone()
	return IBoundingBox(self.x, self.y, self.body:getType(), 
		self.shapeType, self.a, self.b, self.c)
end

return IBoundingBox
