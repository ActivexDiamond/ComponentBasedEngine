local class = require "libs.cruxclass"
local FilepathUtils = require "utils.FilepathUtils"
local EShapes = require "behavior.EShapes"
local Game = require "core.Game"

local Registry = class("Registry")
function Registry:init()
	error "Attempting to initialize static class."
end

---Data Functions
local function data(d)
	local t = Registry.static
	local id = d[1]
	t[id] = t[id] or {}
	
	for k, v in pairs(d) do
		if k ~= 1 then t[id][k] = v end
	end
end

local function loadAllData()
	local lovePath = FilepathUtils.love.path.istatsData
	local luaPath = FilepathUtils.lua.path.istatsData
	local files = love.filesystem.getDirectoryItems(lovePath)
	
	print("Loading all data.")
	for k, v in ipairs(files) do
		print(k, v)
		if v:sub(1, 1) ~= '.' then
			local type = love.filesystem.getInfo(lovePath .. v).type
			if type == 'file' then love.filesystem.load(lovePath .. v)() end
		end
	end
	print("Finished loading all data.")
end

---Data
_G.data = data
loadAllData()
_G.data = nil

--- Mutables
function Registry.static:applyStats(id, inst)
	if self[id] and self[id].stats then
		for k, v in pairs(self[id].stats) do
			inst[k] = v
		end
		return next(self[id].stats) ~= nil
	end 
	return false
end


---		Defaults
---Common Stats
Registry.DEFAULT_NAME = "Unnamed"
Registry.DEFAULT_DESC = "Missing desc."

---Rendering
Registry.DEFAULT_SPR = nil

---Physics
Registry.DEFAULT_BODY_DENSITY = nil
Registry.DEFAULT_BODY_MASS = nil	--As to use Box2D's internal mass computation.
Registry.DEFAULT_BODY_FRICTION = nil
Registry.DEFAULT_BODY_RESTITUTION = nil
Registry.DEFAULT_SHAPE_TYPE = EShapes.RECT
Registry.DEFAULT_SHAPE_A = 1
Registry.DEFAULT_SHAPE_B = 1

---Health
Registry.DEFAULT_MAX_HEALTH = 100

--Registery.DEFAULT_

---		Public Getters
---Common Stats
function Registry.static:getName(id)
	return self[id] and self[id].name or "$" .. id
end

function Registry.static:getDesc(id)
	return self[id] and self[id].desc or self.DEFAULT_DESC
end

---Rendering
function Registry.static:getSpr(id)
	
end

---Physics
function Registry.static:getBodyDensity(id)
	return self[id] and self[id].body and self[id].body.density or self.DEFAULT_BODY_DENSITY
end

function Registry.static:getBodyMass(id)
	return self[id] and self[id].body and self[id].body.mass or self.DEFAULT_BODY_MASS
end

function Registry.static:getBodyFriction(id)
	return self[id] and self[id].body and self[id].body.friction or self.DEFAULT_BODY_FRICTION
end

function Registry.static:getBodyRestitution(id)
	return self[id] and self[id].body and self[id].body.rest or self.DEFAULT_BODY_RESTITUTION
end

function Registry.static:getShapeType(id)
	return (self[id] and self[id].body and 
		EShapes[self[id].body.shape or ""]) or self.DEFAULT_SHAPE_TYPE
end

function Registry.static:getShapeDat(id)
	if self[id] and self[id].body then
		local b = self[id].body
		return b.w or b.r or self.DEFAULT_SHAPE_A, b.h or self.DEFAULT_SHAPE_B
	else return self.DEFAULT_SHAPE_A, self.DEFAULT_SHAPE_B end
end

---Health
function Registry.static:getMaxHealth(id)
	return self[id] and self[id].maxHealth or self.DEFAULT_MAX_HEALTH
end

return Registry