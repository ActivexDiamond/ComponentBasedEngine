local Mixins = require "libs.Mixins"
local IGuiElement = require "gui.IGuiElement"

------------------------------ Setup ------------------------------
local IGuiIcon = Mixins("IGuiIcon", IGuiElement)--, IDrawable)
function IGuiIcon:__postInit()
	self.gui = false
end

------------------------------ API ------------------------------
function IGuiIcon:tickGui(gui, pos, index)
	local spr, sx, sy = self:getSprInv()
	gui:Image(spr, pos.x, pos.y)
end
------------------------------ Callbacks ------------------------------

------------------------------ Getters/Setters ------------------------------


return IGuiIcon
