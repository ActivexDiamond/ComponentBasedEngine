local class = require "libs.cruxclass"
local Item = require "template.Item"

local suit  = require "libs.suit"

local Filter = require "inv.Filter"
local ItemStack = require "inv.ItemStack"
local Slot = require "inv.Slot"

local IMultiContainer = require "inv.IMultiContainer"
local IGuiElement = require "gui.IGuiElement"

local Game = require "core.Game"
------------------------------ Helper Methods ------------------------------

------------------------------ Constructor ------------------------------
--local Inventory = class("Inventory"):include(IMultiContainer, IGuiElement)
local Inventory = class("Inventory"):include(IGuiElement, IMultiContainer)
--local Inventory = class("Inventory"):include(IMultiContainer, IGuiElement)
--function Inventory:init(rows, cols, slots, inFilters, outFilters, ovr, parent)
function Inventory:init(t)
	t = t or {}
	self.children = {}
	
	self.gui = t.gui or suit.new()
	local g = self.gui
	g.elements = self.children
	g.x, g.y = t.x, t.y
	g.rows, g.cols = t.rows, t.cols
	g.cellW, g.cellH = self:_getJoinedVal(t.cellW, Game.graphics.CELL_W, nil, t.cellH, Game.graphics.CELL_H, nil)
--	g.padX, g.padY = t.padX or Game,, t.padY
	g.padX, g.padY = self:_getJoinedVal(t.padX, Game.graphics.CELL_PAD_X, nil, t.padY, Game.graphics.CELL_PAD_Y, nil)
	
	self:_setChildren(t.slots or {})
	for i = #self.children + 1, (g.rows or 1) * (g.cols or 1) do
		self:_addChild(Slot())
	end
end

------------------------------ GUI Methods ------------------------------
--function Inventory:tickGui()
	--self:tickElements(400, 200, 48, 48, 2, 3, 8, 8, self.children)
--	self:tickElements(self.children, {x = 300, y = 50, 
--			cols = 2, rows = 3, cellW = 48, padX = 8})
--end

------------------------------ Access Methods ------------------------------


------------------------------ Callbacks ------------------------------
function Inventory:_onChildUpdate(child, msg, index)
	if msg then
		if msg == 'LMB' then self:_onLMB(child, index)
		elseif msg == 'RMB' then self:_onRMB(child, index) end
	end
end

------------------------------ Direct Access Methods ------------------------------

------------------------------ Filter-Related Methods ------------------------------

------------------------------ Internals ------------------------------
function Inventory:_onLMB(slot, index)
	local mouseSlot = Game.player:getMouseSlot()
											-- mouse	;	slot
	if mouseSlot:getItemStack() then
		if slot:getItemStack() then			--	1	;	1
			if slot:combine(mouseSlot) == -1 then
				local mStack, sStack = mouseSlot:getItemStack(), slot:getItemStack()
				mouseSlot:_setChild(sStack)
				slot:_setChild(mStack)
			end
		else slot:combine(mouseSlot) end	--	1	;	0
	elseif slot:getItemStack() then			--	0	;	1
		mouseSlot:combine(slot)
	end										--	0	;	0
end

function Inventory:_onRMB(slot, index)
	local mouseSlot = Game.player:getMouseSlot()
											-- mouse	;	slot
	if mouseSlot:getItemStack() then
		if slot:getItemStack() then			--	1	;	1
			if slot:combine(mouseSlot, 1) == -1 then
				local mStack, sStack = mouseSlot:getItemStack(), slot:getItemStack()
				mouseSlot:_setChild(sStack)
				slot:_setChild(mStack)
			end
		else slot:combine(mouseSlot, 1) end	--	1	;	0
	elseif slot:getItemStack() then			--	0	;	1
		local a = slot:getItemStack():getAmount()
		local take = a % 2 == 0 and a/2 or math.floor(a/2) + 1
		mouseSlot:combine(slot, take)
	end										--	0	;	0

end

------------------------------ Getters / Setters ------------------------------
--local function getCapItem(item) return item:getMaxStack() end
--local function getCapItemStack(its) return its.child:getMaxStack() end
--local function getCap(self) 	
--	return self.child and (self.child.child:getMaxStack() - self.child:getAmount())
--end
--
--function Inventory:getCapacity(source)
--	return (utils.ovld({nil, source, nil, self, nil},
----	return (utils.ovld({self, source, 1},
--			getCapItem, {Item},
--			getCapItemStack, {ItemStack},
--			getCap, {self}
--	))-- or 0
--end
--
--function Inventory:getInFilter() return self.inFilter end
--function Inventory:getOutFilter() return self.outFilter end
--function Inventory:getItemStack() return self:getChild() end
--
--function Inventory:setInFilter(f) self.inFilter = f or Filter() end
--function Inventory:setOutFilter(f) self.outFilter = f or Filter() end
--function Inventory:setItemStack(its) 
--	self:_setChild(its)
--end

------------------------------ Util-Getters (For Quick Access) ------------------------------

------------------------------ Object-Common Methods ------------------------------
function Inventory:clone()
	error "TODO"
end

return Inventory

