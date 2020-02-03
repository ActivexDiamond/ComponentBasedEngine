local class = require "libs.cruxclass"

local FilepathUtils = require "utils.FilepathUtils"

local EShapes = require "behavior.EShapes"
local IBoundingBox = require "behavior.IBoundingBox"
local WeaponDef = require "template.WeaponDef"
--local Item = require "template.Item"

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
		assert(k == "__f" or k == "__d", "Only __f or __d are auto-created. Attempted to index " .. k)
		t[k] = {}
		return t[k]
	end
}
local mtDefaultsHolder = {			--If the user attempts to index r.className 
	__index = function(t, k)			--without initializing it, initialize it implicitly.
		if k == "idv" or k == "instv" then return end
		local idv = setmetatable({}, mtFuncHolder)
		local instv = setmetatable({}, mtFuncHolder)
		t[k] = setmetatable({idv = idv, instv = instv}, mtFuncHolder)
		return t[k]
	end
}

local tempDefaultsHolder = setmetatable({}, mtDefaultsHolder)

local dslEnv = {
	print = print, pairs = pairs, ipairs = ipairs,
	string = string, table = table, os = os,
	tostring = tostring, tonumber = tonumber,
	assert = assert, error = error,
	love = love,
	
	data = data,
	r = tempDefaultsHolder,
	
	WeaponDef = WeaponDef,
	EShapes = EShapes,
	IBoundingBox = IBoundingBox,
	masks = IBoundingBox.masks, 
	Item = Item,
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
		if DEBUG.DATAPACK_LOAD then print('\t' .. file) end
		local type = love.filesystem.getInfo(file).type
		if type == 'directory' then loadDir(file .. '/', env)
		elseif type == 'file' then loadFile(file, env) end
	end
end

local function loadAll(defaultsEnv, dataEnv)
	print("Loading defaults.")
	loadDir(FilepathUtils.love.path.istatsDefaults, defaultsEnv)
	if DEBUG.DATAPACK_CONTENTS then utils.t.print("defaults", defaultsEnv.r) end
	 
	print("Loading data.")
	loadDir(FilepathUtils.love.path.istatsData, dataEnv)
	if DEBUG.DATAPACK_CONTENTS then utils.t.print("data", Registry.data) end
	
	print("Done loading datapack.")
	print()
end

------------------------------ Data Loading ------------------------------
do
	Registry.data = {}

	loadAll(dslEnv, dslEnv)
--	Registry.defaults = tempDefaultsHolder
	Registry.defaults = dslEnv.r
	
--	local dat, def = Registry.data, Registry.defaults
--	local dat, def = Registry.data, tempDefaultsHolder
--	print(" --- r ---") 
--	for k, v in pairs(dslEnv.r.Thing.idv or {}) do
--		print(k, v)
--	end
--	print()
--	
--	print(" --- REG ---") 
--	for k, v in pairs(def.Thing.idv or {}) do
--		print(k, v)
--	end
--	print()	
--	print(" --- data ---") 
--	for k, v in pairs(dat) do
--		print(k, v)
--	end
--	print()
--	
--	for name, t in pairs(def) do
--	
--		print(" --- " .. name .. ".idv ---") 
--		for k, v in pairs(t.idv or {}) do
--			print(k, v)
--		end
--		print()
--		
--		
--		print(" --- " .. name .. ".instv ---") 
--		for k, v in pairs(t.instv or {}) do
--			print(k, v)
--		end
--		print()
--	end	
end

------------------------------ Util Methods------------------------------
local function getterStr(str)
	return "get" .. (str:gsub("^%l", string.upper)) 
end 

local function appendTable(t1, t2)
	for _, v in ipairs(t2) do
		table.insert(t1, v)
	end
end

------------------------------ Hierarchy Methods ------------------------------
local function fetchDirectHierarchy(class)
	local h = {class.__name__}
	if DEBUG.REG_APPLY then print("class.__name__", class.__name__) end
	for k, v in ipairs(class.__mixins__) do
		if DEBUG.REG_APPLY then print("\tmixins.__name__", v.__name__) end
		table.insert(h, v.__name__)
	end
	return h
end

local function fetchHierarchy(inst)
	local class = inst.class
	local h = fetchDirectHierarchy(class)
	repeat
		local super = class.super
		if super then
			appendTable(h, fetchDirectHierarchy(super))
		end
		class = super
	until not class
	return h
end




------------------------------ Apply Stats Steps ------------------------------
local function getterFunc(id, inst, var, defs, default, dat, datum)
	if var == "__f" or var == "__d" then return nil end
	local f, d = defs.__f[var], defs.__d[var]
	local un = unpack
	local args = {id, inst, var, defs, default, dat, datum}
	if f and d then
		return function() return (datum and d(un(args))) or f(un(args)) end
	elseif f then
		return function() return datum or f(un(args)) end
	elseif d then
		return function() return (datum and d(un(args))) or default end
	else
		return function() return datum or default end 
	end
end
--[[
cases: (for idv)
	f + d
		return (data and d(data)) or f() 
	f
		return data or f()
	d
		return (data and d(data)) or default
	0
		return data or default
--]]

local function handleIdvs(id, inst, h)
	local dat = Registry.data
	for _, name in ipairs(h) do
		local defs = Registry.defaults[name].idv or {}
		for var, default in pairs(defs) do
			local fstr = getterStr(var)
			local idDat = dat[id] or {}
			local datum = idDat[var]
			inst[fstr] = getterFunc(id, inst, var, defs, default, idDat, datum)
		end
	end
end

local function handleInstvs(id, inst, h)
	local dat = Registry.data
	for _, name in ipairs(h) do
		local defs = Registry.defaults[name].instv or {}
		for var, default in pairs(defs) do
			local datum = dat[id] and dat[id][var]
			local f = getterFunc(id, inst, var, defs, default, dat[id], datum)
			inst[var] = f and f()
		end
	end
end

------------------------------ Apply Stats ------------------------------
function Registry:apply(id, inst)
	local h = fetchHierarchy(inst)
--	for k, v in ipairs(h) do print(k, v) end
	handleIdvs(id, inst, h)
	handleInstvs(id, inst, h)
end

--_G.Registry = Registry
--local Zombie = require "template.Zombie"
--Zombie(0, 0)

return Registry