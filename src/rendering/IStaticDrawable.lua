local Mixins = require "libs.Mixins"

------------------------------ Setup ------------------------------
local IStaticDrawable = Mixins("IStaticDrawable")
--Mixins.onPostInit(IStaticDrawable, function(self)
--end)

------------------------------ API ------------------------------
function IStaticDrawable:draw(g)
	
end
------------------------------ Callbacks ------------------------------

------------------------------ Getters/Setters ------------------------------


return IStaticDrawable
