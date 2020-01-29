

------------------------------ Thing ------------------------------
t = r.Thing.idv

t.name = "Unnamed"
t.desc = "Missing desc."

------------------------------ Rendering ------------------------------

--t.spr = nil

------------------------------ IBoundingBox ------------------------------
t = r.IBoundingBox.idv

t.bodyDensity = 1
t.bodyMass = 1	--As to use Box2D's internal mass computation.
t.bodyFriction = 0
t.bodyRestitution = 0
t.shapeType = EShapes.RECT
t.shapeA = 1
t.shapeB = 1

function t.__f.shapeA(id, inst, var, defs, default, dat, datum)
	return (dat and (dat.r or dat.w)) or default
end
function t.__f.shapeB(id, inst, var, defs, default, dat, datum)
	return dat and dat.h or default
end

--[[

if dat[r] then return it
if dat[w] then return it
else return default

--]]