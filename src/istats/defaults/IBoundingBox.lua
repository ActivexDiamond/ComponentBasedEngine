------------------------------ Physics Vars ------------------------------
local m = IBoundingBox.masks
t = r.IBoundingBox.idv
t.classCategories = {}
t.classMasks = {}


t.bodyDensity = 1
t.bodyMass = 1	--As to use Box2D's internal mass computation.
t.bodyFriction = 0
t.bodyRestitution = 0
t.shapeType = IBoundingBox.RECT
t.shapeA = 1
t.shapeB = 1

function t.__f.shapeA(id, inst, var, defs, default, dat)
	return (dat and (dat.r or dat.w)) or default
end
function t.__f.shapeB(id, inst, var, defs, default, dat)
	return dat and dat.h or default
end

--[[

if dat[r] then return it
if dat[w] then return it
else return default

--]]

------------------------------ Categories ------------------------------
local c  = t.classCategories	--self:setCategory(c)

c.unassigned = m.MP

c.Block = m.BLOCK	
c.ItemDrop = m.ITEM_DROP

------------------------------ Masks ------------------------------
local k = t.classMasks	--self:setMask(m.SOLID - k)

k.unassigned = 0

k.ItemDrop = m.PRJ + m.NPC
k.Npc = m.NPC + m.ITEM_DROP


t.category = 0
t.mask = 0

function t.__f.category(id, inst, var, defs, default, dat)
	local cat = c[inst.class.__name__]	--class default, if any
	return cat or c.unassigned
end

function t.__f.mask(id, inst, var, defs, default, dat)
	local mask = k[inst.class.__name__]	--class default, if any
	return m.SOLID - (mask or k.unassigned)
end

function t.__d.mask(id, inst, var, defs, default, dat, datum)
	return m.SOLID - datum
end



