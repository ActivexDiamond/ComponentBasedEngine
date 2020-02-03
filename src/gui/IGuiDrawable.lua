local Mixins = require "libs.Mixins"
local suit  = require "libs.suit"
local IGuiElement = require "gui.IGuiElement"

------------------------------ Setup ------------------------------
local IGuiTopElement = Mixins("IGuiTopElement")
Mixins.onPostInit(IGuiTopElement, function(self)
	self.gui = self.gui or {}
	self.gui.g = self.gui.g or suit.new()
	self.gui.elements = self.gui.elements or {}
	
	--screen-coords
	local sw, sh = love.window.getMode()
	self.gui.x = self.gui.x or sw/2
	self.gui.y = self.gui.y or sh/2
end)

------------------------------ API ------------------------------
function IGuiTopElement:updateGui(gui)
	--Default implementation
	gui.layout:reset(gui.x, gui.y)
	
	for k, v in ipairs(gui.elements) do
		if type(k) == 'table' and k:instanceof(IGuiElement) then
			k:updateGuiElements()
		end
	end
end

function IGuiTopElement:tick(dt)
	self:updateGui(self.gui)
end

function IGuiTopElement:draw(g)	-- the usual g = love.graphics
	self.gui:draw()				-- made to have an interface identical to IDrawable-interfaces.
end
------------------------------ Callbacks ------------------------------

------------------------------ Getters/Setters ------------------------------


return IGuiTopElement
