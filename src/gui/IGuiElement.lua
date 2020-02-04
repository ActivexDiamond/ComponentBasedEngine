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
		self.gui.padX, self.gui.padY = 0, 0
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
function IGuiElement:tickElements(elements, overrides)
--function IGuiElement:tickElements(x, y, cellW, cellH, cols, rows, padX, padY, elements, gui)
	local ovr = overrides or {}
	local gui, x, y, rows, cols, cellW, cellH, padX, padY;
	
	--vars take their values, in order, from:
	--ovr.var, ovr.gui.var, self.gui.var, DEFAULT
	local gui = ovr.gui or self.gui
	elements = elements or gui.elements or {}
	x = ovr.x or gui.x or 0
	y = ovr.y or gui.y or 0
	rows = ovr.rows or gui.rows or 1
	cols = ovr.cols or ovr.rows or gui.cols or gui.rows or #elements
	cellW = ovr.cellW or gui.cellW or 1
	cellH = ovr.cellH or ovr.cellW or gui.cellH or gui.cellW or 1
	padX = ovr.padX or gui.padX or 0
	padY = ovr.padY or ovr.padX or gui.padY or gui.padX or 0
	--TODO move fallback-methodology into a helper-method.
	
	gui.layout:reset(x, y, padX, padY)
	gui.layout:setSize(cellW, cellH)

	for y = 1, rows do
		gui.layout:push()	
		for x = 1, cols do
			local i = x + ((y - 1) * cols)
			if i > #elements then return end
			local place = self:_createPlace(gui.layout:col())
			elements[i]:tickGui(gui, i, place)
		end
		gui.layout:pop()
		gui.layout:row()
	end
end

function IGuiElement:_createPlace(x, y, w, h)
	return function() return x, y, w, h end
end

------------------------------ Getters/Setters ------------------------------
function IGuiElement:setDims(cols, rows)
	self.guis.cols = cols or 1
	self.guis.rows = rows or cols or 1 
end

function IGuiElement:setCellSize(w, h)
	self.gui.cellW = w
	self.gui.cellH = h or w
end

function IGuiElement:setPos(x, y)
	self.gui.x = x or 0
	self.gui.y = y or 0
end

function IGuiElement:setPadding(x, y)
	self.gui.padX = x
	self.gui.padY = y or x
end

return IGuiElement
