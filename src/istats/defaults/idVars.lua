local EShapes = require "behavior.EShapes"

local t = {}

------------------------------ Thing ------------------------------
t.NAME = "Unnamed"
t.DESC = "Missing desc."

------------------------------ Rendering ------------------------------
t.SPR = nil

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
