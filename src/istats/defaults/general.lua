

------------------------------ Thing ------------------------------
t = r.Thing.idv

t.name = "Unnamed"
t.desc = "Missing desc."

function t.__f.name(id, inst, var, defs, default)
	return '$' .. id
end
------------------------------ Rendering ------------------------------

--t.spr = nil

------------------------------ Item ------------------------------
t = r.Item.idv

t.maxStack = 64

t.mass = 1
--t.size = Item.SMALL
t.tags = {}

local sprInvPath = "assets/spr/inv/"
t.sprInv = love.graphics.newImage(sprInvPath .. "missingTexture.png")

function t.__d.sprInv(id, inst, var, defs, default, dat, datum)
	return love.graphics.newImage(sprInvPath .. datum)
end