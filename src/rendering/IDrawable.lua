local Mixins = require "libs.Mixins"

------------------------------ Setup ------------------------------
local IDrawable = Mixins("IDrawable")
--function IItemDrawable:__postInit()
--	
--end

------------------------------ API ------------------------------
function IDrawable:draw(g)
	error "Abstract method."
end
------------------------------ Callbacks ------------------------------

------------------------------ Getters/Setters ------------------------------


return IDrawable
