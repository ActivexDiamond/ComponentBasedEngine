local class = require "libs.cruxclass"
local Item = require "template.Item"

------------------------------ Helper Methods ------------------------------

------------------------------ Constructor ------------------------------
local ItemStack = class("ItemStack")
function ItemStack:init(item, amount, parent)
	self.item = item
	self.item:setParent(self)
	self.amount = amount or self.DEFAULT_AMOUNT
	self:_updateMass()
	self.parent = parent		--Slot, ItemDrop, or nil.
	
end

------------------------------ Constants ------------------------------
ItemStack.DEFAULT_AMOUNT = 1
 
------------------------------ Main API ------------------------------
function ItemStack:add(its, n)
	local cap = self.item:getMaxStack() - self.amount				--get open space
	if cap <= 0 or not self.item:equals(its:getItem()) then return 0 end --if none, or not equal
	n = n or its.amount							--else, take given amount or as much as possible.
	local took = its:take(math.min(cap, n))		--take all, or whatever fits.
	self.amount = self.amount + took
	self:_updateMass()
	return took									--return the difference
end

function ItemStack:take(n)
	local dif = self.amount > n and n or self.amount
	self.amount = self.amount - dif
	self:_updateMass()
	return dif
	
end

------------------------------ Internals ------------------------------
function ItemStack:_updateMass()
	self.mass = self.item:getMass() * self.amount
end

------------------------------ Getters / Setters ------------------------------
function ItemStack:getCapacity() return self.item:getMaxStack() - self.amount end

function ItemStack:getItem() return self.item end
function ItemStack:getAmount() return self.amount end
function ItemStack:getMass() return self.mass end
function ItemStack:getParent() return self.parent end

function ItemStack:setItem(itm) self.item = itm; self:_updateMass() end
function ItemStack:setAmount(a) self.amount = a; self:_updateMass() end
function ItemStack:setParent(p) self.parent = p end

function ItemStack:setContents(i, amount)	--Also takes an ItemStack
	if i:instanceof(ItemStack) then
		self.item = i:getItem():clone()
		self.amount = i:getAmount()
	elseif i:instanceof(Item) then
		self.item = i
		self.amount = amount or self.DEFAULT_AMOUNT
	else error "Can only take either an ItemStack, or Item and amount(default = 1)." end
	self:_updateMass()
end

------------------------------ Util-Getters (For Quick Access) ------------------------------
function ItemStack:getItemSize() return self.item:getSize() end
function ItemStack:getItemTags() return self.item:getTags() end

------------------------------ Object-Common Methods ------------------------------
function ItemStack:clone()
	return ItemStack(self.item:clone(), self.amount, self.parent)
end

return ItemStack

--[[

add(its): Adds its to itself, if possible. Returns the added amount. (mutates it's arg)
take(n):  Removes n from itself. Returns the removed amount.


--]]