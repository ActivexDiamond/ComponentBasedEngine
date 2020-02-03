local Mixins = require "libs.Mixins"
local suit  = require "libs.suit"

------------------------------ Setup ------------------------------
local IGuiElement = Mixins("IGuiElement")
function IGuiElement:__postInit()
	if not self.gui then
		self.gui = suit.new()
		self.gui.elements ={}
		--screen-coords
		local sw, sh = love.window.getMode()
		self.gui.x = self.gui.x or sw/2
		self.gui.y = self.gui.y or sh/2
	end
end

------------------------------ API ------------------------------

function IGuiElement:tickGui(gui, pos)		--called with no args for top-levels.
	self:tickElements()
end

function IGuiElement:drawGui(g)						-- 'g' to match IDrawable's interface.
	if self.gui.draw then self.gui:draw() end
end
------------------------------ Internals ------------------------------
function IGuiElement:tickElements(x, y, cellW, cellH, cols, rows, padX, padY, elements, gui)
	gui = gui or self.gui
	elements = elements or gui.elements or {}
	rows = rows or 1
	cols = cols or #elements
	gui.layout:reset(x or (gui.x or 0), y or (gui.y or 0), padX, padY)
	gui.layout:setSize(cellW, cellH)

	for y = 1, rows do
		gui.layout:push()	
		for x = 1, cols do
			local i = x + ((y - 1) * cols)
			if i > #elements then return end
			local place = self:_createPlace(gui.layout:col())
			elements[i]:tickGui(gui, place)
		end
		gui.layout:pop()
		gui.layout:row()
	end
end

function IGuiElement:_createPlace(x, y, w, h)
	return function() return x, y, w, h end
end

------------------------------ Getters/Setters ------------------------------


return IGuiElement
