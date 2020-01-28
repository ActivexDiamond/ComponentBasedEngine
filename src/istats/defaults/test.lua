local EShapes = require "behavior.EShapes"

-- global r is used by the registry to collect the defaults

------------------------------ Thing ------------------------------
t = r.Thing			-- r's __index metamethod will create r[k] = k and return it

t.NAME = "Unnamed"
t.DESC = "Missing desc."

------------------------------ Rendering ------------------------------
t = r.IDrawable					--same case as above

t.SPR = nil
t.width = topx(16)					--some global methods are passed for ease
t.height = topx(16)

function t.__f:width(id)			--the table returned by r's index metamethod	
	local w							--has it's metatable set to, if t.__f is nil:
	w = self:getSpr(id):getWidth()	--declare t.__f as a table and return it.
	return w						--if t.__f is explicitly declared as a new table,
end									--or has any table value assigned to it, it's fine.
									--__f itself has no metatable.
function t.__f:height(id)			--the registry only looks at __f, if any,
	local h							--for default-defined functions
	h = self:getSpr(id):getHeight()
	return h
end

--[[
t.__f is used for default-fallbacks: are called with f(instance, id, k, v)
	- If present for t.__f[k], is indented into getVar() as the default-fallback.
	- Else, the native-default is indented directly 	  
t.__d is used for data-computation: are called with f(instance, id, k, v, datum)

	1- Take priority over a native-default.					
	2- Are passed the var (k) and native-default (v), if any.
	3- [__d only] Are passed the datum from the datapack (datum), if any.

	Terminology:
		r.t = Registry.defaults.i__v.className
		
		instance = the instance being instantiated
		k = var 								--aka what is indexed with in r.t[k]
		v = r.t[k]  							--aka var
		native-default = r.t[k] 				--aka v
		default-fallback = r.t.__f[k] --	

--]] 
------------------------------ IBoundingBox ------------------------------
t.BODY_DENSITY = nil
t.BODY_MASS = nil	--As to use Box2D's internal mass computation.
t.BODY_FRICTION = nil
t.BODY_RESTITUTION = nil
t.SHAPE_TYPE = EShapes.RECT
t.SHAPE_A = 1
t.SHAPE_B = 1

------------------------------ IHealth ------------------------------
t.MAX_HEALTH = 100

return t
