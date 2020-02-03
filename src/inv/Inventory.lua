local class = require "libs.cruxclass"
local Item = require "template.Item"

local Filter = require "inv.Filter"
local ItemStack = require "inv.ItemStack"
local IMultiContainer = require "inv.IMultiContainer"
local IGuiElement = require "gui.IGuiElement"

------------------------------ Helper Methods ------------------------------

------------------------------ Constructor ------------------------------
--local Inventory = class("Inventory"):include(IMultiContainer, IGuiElement)
local Test = class("Test")

local Inventory = class("Inventory"):include(IGuiElement, IMultiContainer)
--local Inventory = class("Inventory"):include(IMultiContainer, IGuiElement)
function Inventory:init(slots, parent)
	self:_setChildren(slots)
	self:_setParent(parent)			--Inv, or nil.
end

------------------------------ GUI Methods ------------------------------
function Inventory:tickGui()
	self:tickElements(400, 200, 48, 48, 2, 3, 8, 8, self.children)
end

------------------------------ Access Methods ------------------------------


------------------------------ Callbacks ------------------------------
--function Inventory:_onChildUpdate()
--	if self.child and self.child:getAmount() == 0 then
--		self:_setChild(nil)
--	end
--end

------------------------------ Direct Access Methods ------------------------------

------------------------------ Filter-Related Methods ------------------------------

------------------------------ Internals ------------------------------

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
