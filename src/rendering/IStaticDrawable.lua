local Mixins = require "libs.Mixins"
local IDrawable = require "rendering.IDrawable"

------------------------------ Setup ------------------------------
local IStaticDrawable = Mixins("IStaticDrawable", IDrawable)
--Mixins.onPostInit(IStaticDrawable, function(self)
--end)

------------------------------ API ------------------------------
function IStaticDrawable:draw(g)
	
end
------------------------------ Callbacks ------------------------------

------------------------------ Getters/Setters ------------------------------


return IStaticDrawable
