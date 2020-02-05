local Mixins = require "libs.Mixins"

------------------------------ Setup ------------------------------
local IGuiIcon = Mixins("IGuiIcon")--, IDrawable)
--function IItemDrawable:__postInit()
--	
--end

------------------------------ API ------------------------------
function IGuiIcon:draw(gui, x, y)
	local spr, sx, sy = self:getSprInv()
	gui:Image(spr, x, y)
end
------------------------------ Callbacks ------------------------------

------------------------------ Getters/Setters ------------------------------


return IGuiIcon
