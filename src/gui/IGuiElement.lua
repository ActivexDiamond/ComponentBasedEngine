local Mixins = require "libs.Mixins"
local suit  = require "libs.suit"

------------------------------ Setup ------------------------------
local IGuiElement = Mixins("IGuiElement")
function IGuiElement:__postInit()
	if self.gui == nil then
		self.gui = suit.new()
		self.gui.elements ={}
		--screen-coords
		local sw, sh = love.window.getMode()
		self.gui.x = self.gui.x or sw/2
		self.gui.y = self.gui.y or sh/2
		self.gui.padX, self.gui.padY = 0, 0
	end
	print("postInit IGuiElement")
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
	local ovr = overrides or {}
	local gui, gx, gy, rows, cols, cellW, cellH, padX, padY;
	--vars take their values, in order, from:
	--ovr.var, gui.var, DEFAULT
	--gui comes from ovr.gui or self.gui
	--(if ovr.gui but not ovr.gui.var ; var still goes to default)
	local gui = ovr.gui or self.gui
	elements = elements or gui.elements or {}

	gx,		gy		= self:_getVal(			ovr.x,		gui.x,		0,		ovr.y,		gui.y,		0)
	rows,	cols	= self:_getJoinedVal(	ovr.rows,	gui.rows,	1,		ovr.cols,	gui.cols,	#elements)
	cellW,	cellH	= self:_getJoinedVal(	ovr.cellW,	gui.cellW,	1, 		ovr.cellH,	gui.cellH,	1)
	padX,	padY	= self:_getJoinedVal(	ovr.padX,	gui.padX,	0, 		ovr.padY,	gui.padY,	0)

--	gx,		gy		= self:_getVal(			ovr.x,		ovr.y,			gui.x,		gui.y,			0,		0)
--	rows,	cols	= self:_getJoinedVal(	ovr.rows,	ovr.cols,		gui.rows,	gui.cols,		1,		#elements)
--	cellW,	cellH	= self:_getJoinedVal(	ovr.cellW,	ovr.cellH,		gui.cellW, 	gui.cellH,		1,		1)
--	padX,	padY	= self:_getJoinedVal(	ovr.padX,	ovr.padY,		gui.padX, 	gui.padY,		0,		0)

	
	gui.layout:reset(gx, gy, padX, padY)
	gui.layout:setSize(cellW, cellH)
	gui.layout:left(cellW, cellH)

	for y = 1, rows do
		gui.layout:push()	
		for x = 1, cols do
			local i = x + ((y - 1) * cols)
			if i > #elements then return end
			local pos = self:_createPos(gui.layout:col())
			elements[i]:tickGui(gui, pos, i)
		end
		gui.layout:pop()
		gui.layout:row()
	end
end

function IGuiElement:_getVal(ovrA, guiA, defaultA, ovrB, guiB, defaultB)
	local a = ovrA or guiA or defaultA
	local b = ovrB or guiB or defaultB
	return a, b
end

function IGuiElement:_getJoinedVal(ovrA, guiA, defaultA, ovrB, guiB, defaultB)
	local a = ovrA or guiA or defaultA
	local b = ovrB or ovrA or guiB or guiA or defaultB
	return a, b
end

function IGuiElement:_createPos(x, y, w, h)
	return setmetatable({x = x, y = y, w = w, h = h},
			{__call = function() return x, y, w, h end})
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
 