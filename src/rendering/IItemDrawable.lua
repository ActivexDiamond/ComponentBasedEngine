local Mixins = require "libs.Mixins"
local IDrawable = require "rendering.IDrawable"

------------------------------ Setup ------------------------------
local IItemDrawable = Mixins("IItemDrawable")--, IDrawable)
--function IItemDrawable:__postInit()
--	
--end

------------------------------ API ------------------------------
function IItemDrawable:draw(g, x, y)
	local spr, sx, sy = self:getSprInv()
	--g.draw(spr, x, y, 0, sx, sy)
	g.draw(spr, x, y)
	print('item draw', g, x, y, spr, sx, sy)
end
------------------------------ Callbacks ------------------------------

------------------------------ Getters/Setters ------------------------------


return IItemDrawable
