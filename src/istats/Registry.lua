local class = require "libs.cruxclass"

local FilepathUtils = require "utils.FilepathUtils"
local EShapes = require "behavior.EShapes"
local IBoundingBox = require "behavior.IBoundingBox"
local WeaponDef = require "template.WeaponDef"

--local Game = require "core.Game"

------------------------------ Constructor ------------------------------
local Registry = class("Registry")
function Registry:init()
	error "Attempting to initialize static class."
end

------------------------------ Data Env ------------------------------
local function data(d)
	local t = Registry.static.data
	local id = d[1]
	t[id] = t[id] or {}
	
	for k, v in pairs(d) do
		if k ~= 1 then t[id][k] = v end
	end
end

local mtFuncHolder = {			--Same as the above, but only for __f / __d.
	__index = function(t, k)
		assert(k == "__f" or k == "__d", "Only __f or __d are auto-created. Cannot index nil values.")
		t[k] = {}
		return t[k]
	end
}
local mtTempHolders = {			--If the user attempts to index r.className 
	__index = function(t, k)			--without initializing it, initialize it implicitly.
		t[k] = setmetatable({}, mtFuncHolder)
		return t[k]
	end
}

local tempDefaultsHolder
do
	local idv = setmetatable({}, mtTempHolders)
	local instv = setmetatable({}, mtTempHolders)
	tempDefaultsHolder = {idv = idv, instv = instv}
end


local DslEnv = {
	print = print,
	assert = assert,
	error = error,
	
	data = data,
	r = tempDefaultsHolder,
	
	WeaponDef = WeaponDef,
	EShapes = EShapes,
	IBoundingBox = IBoundingBox, 
}

------------------------------ Data Methods ------------------------------
local function loadFile(file, env)
	local f = love.filesystem.load(file)
	setfenv(f, env)
	f()
end

local function loadDir(dir, env)
	local files = love.filesystem.getDirectoryItems(dir)
	
	for k, v in ipairs(files) do
		local file = dir .. v
		print(file)
		local type = love.filesystem.getInfo(file).type
		if type == 'directory' then loadDir(file .. '/', env)
		elseif type == 'file' then loadFile(file, env) end
	end
end

local function loadAll(defaultsEnv, dataEnv)
	print("Loading defaults.")
	loadDir(FilepathUtils.love.path.istatsDefaults, defaultsEnv)
	print("Loading data.")
	loadDir(FilepathUtils.love.path.istatsData, dataEnv)
	print("Done loading datapack.")
end

------------------------------ Data Loading ------------------------------
do
	Registry.static.data = {}
	
	loadAll(DslEnv, DslEnv)
	setmetatable(tempDefaultsHolder.idv, {})
	setmetatable(tempDefaultsHolder.instv, {})
	Registry.static.defaults = tempDefaultsHolder
	
end

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



return Registry