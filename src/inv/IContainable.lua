local Mixins = require "libs.Mixins"

------------------------------ Setup ------------------------------
local IContainable = Mixins("IContainable")
function IContainable:__postInit()
	self:_onUpdate()
end

------------------------------ Callbacks ------------------------------
function IContainable:_onUpdate() 
	if self.parent then self.parent:_onChildUpdate(self) end
end

function IContainable:_onParentUpdate() 

end

------------------------------ Getters/Setters ------------------------------
function IContainable:getParent() return self.parent end
function IContainable:_setParent(p)
	self.parent = p	
end

return IContainable
