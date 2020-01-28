local class = require "libs.cruxclass"

local FilepathUtils = require "utils.FilepathUtils"
local EShapes = require "behavior.EShapes"
local WeaponDef = require "template.WeaponDef"

--local Game = require "core.Game"

------------------------------ Constructor ------------------------------
local Registry = class("Registry")
function Registry:init()
	error "Attempting to initialize static class."
end

------------------------------ Data Methods ------------------------------
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

------------------------------ Data ------------------------------
_G.data = data
_G.WeaponDef = WeaponDef
loadAllData()
_G.data = nil
_G.WeaponDef = nil

------------------------------ Defaults ------------------------------
local D_IDV, D_INSTV
do
	D_IDV = require "istats.defaults.idVars"
	D_INSTV = require "istats.defaults.instanceVars"
	local t = require "istats.defaults.masks"
	D_IDV.categories, D_IDV.masks = t.categories, t.masks
end



Registry.defaults = {}
Registry.defaults.idVars = D_IDV
Registry.defaults.instVars = D_INSTV

------------------------------ InstanceVars Applier ------------------------------
function Registry.static:applyStat(id, inst, stat)
	local applied = false
	if D_INSTV[stat] then	--Apply defaults
		for k, v in pairs(D_INSTV[stat]) do inst[k] = v end
		applied = true
	end
			
	if self[id] and self[id].stats and self[id].stats[stat] then	--Apply idata
		for k, v in pairs(self[id].stats[stat]) do inst[k] = v end
		applied = true
	end
	return applied
end

------------------------------ Thing ------------------------------
function Registry.static:getName(id)
	return self[id] and self[id].name or "$" .. id
end

function Registry.static:getDesc(id)
	return self[id] and self[id].desc or self.defaults.DESC
end

------------------------------ Rendering ------------------------------
function Registry.static:getSpr(id)
	
end

------------------------------ IBoundingBox ------------------------------
function Registry.static:getBodyDensity(id)
	return self[id] and self[id].body and self[id].body.density or D_IDV.BODY_DENSITY
end

function Registry.static:getBodyMass(id)
	return self[id] and self[id].body and self[id].body.mass or D_IDV.BODY_MASS
end

function Registry.static:getBodyFriction(id)
	return self[id] and self[id].body and self[id].body.friction or D_IDV.BODY_FRICTION
end

function Registry.static:getBodyRestitution(id)
	return self[id] and self[id].body and self[id].body.rest or D_IDV.BODY_RESTITUTION
end

function Registry.static:getShapeType(id)
	return (self[id] and self[id].body and 
		EShapes[self[id].body.shape or ""]) or D_IDV.SHAPE_TYPE
end

function Registry.static:getShapeDat(id)
	if self[id] and self[id].body then
		local b = self[id].body
		return b.w or b.r or D_IDV.SHAPE_A, b.h or D_IDV.SHAPE_B
	else return D_IDV.SHAPE_A, D_IDV.SHAPE_B end
end

------------------------------ IHealth ------------------------------
function Registry.static:getMaxHealth(id)
	return self[id] and self[id].maxHealth or D_IDV.MAX_HEALTH
end

return Registry