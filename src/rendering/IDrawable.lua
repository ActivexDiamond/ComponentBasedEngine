local Mixins = require "libs.Mixins"

------------------------------ Setup ------------------------------
local IDrawable = Mixins("IDrawable")
--Mixins.onPostInit(IDrawable, function(self)
--end)

------------------------------ API ------------------------------
function IDrawable:draw(g)
	error "Abstract method. Must be implemented. Use IStaticDrawable or IStatefulDrawable for pre-made implementations."
end
------------------------------ Callbacks ------------------------------

------------------------------ Getters/Setters ------------------------------


return IDrawable
