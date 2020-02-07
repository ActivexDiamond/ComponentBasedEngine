local class = require "libs.cruxclass"
local Item = require "template.Item"

local IContainer = require "inv.IContainer"

------------------------------ Helper Methods ------------------------------

------------------------------ Constructor ------------------------------
local ItemStack = class("ItemStack"):include(IContainer)
function ItemStack:init(item, amount, parent)
	self:_setChild(item)
	self.amount = amount or self.DEFAULT_AMOUNT
	self:_setParent(parent)			--Slot, ItemDrop, or nil.
	self:_onUpdate()
end

------------------------------ Constants ------------------------------
ItemStack.DEFAULT_AMOUNT = 1
 
------------------------------ Access Methods ------------------------------

function ItemStack:combine(its, n)
	if not self.child:equals(its:getItem()) then return -1 end 	
	return self:add(its:sub(n))
end

function ItemStack:add(n)
	if n and n > 0 then
		self.amount = self.amount + n
		self:_onUpdate()
		return self.amount - n
	end 
end

function ItemStack:sub(n)
	n = self:_constrainToMin(n)
	self.amount = self.amount - n
	self:_onUpdate()
	return n
end

------------------------------ Internals ------------------------------
function ItemStack:_onUpdate()
	if self.item then self.mass = self.item:getMass() * self.amount end
	IContainer._onUpdate(self)
end

function ItemStack:_onChildUpdate()

end

function ItemStack:_constrainToMin(n)
	return math.min(n or self.amount, self.amount)				
end
------------------------------ Getters / Setters ------------------------------
function ItemStack:getItem() return self:getChild() end
function ItemStack:getAmount() return self.amount end
function ItemStack:getMass() return self.mass end

function ItemStack:setItem(item)
	self:_setChild(item) 
	self:_onUpdate() 
end
function ItemStack:setAmount(a) 
	self.amount = a
	self:_onUpdate() 
end

function ItemStack:setContents(i, amount)	--Also takes an ItemStack
	if i:instanceof(ItemStack) then
		self:setItem(i:getItem():clone())
		self:setAmount(i:getAmount())
	elseif i:instanceof(Item) then
		self:setItem(i)
		self.item = i
		self:setAmount(amount or self.DEFAULT_AMOUNT)
	else error "Can only take either an ItemStack, or Item and amount(default = 1)." end
end

------------------------------ Util-Getters (For Quick Access) ------------------------------
function ItemStack:getItemSize() return self.child:getSize() end
function ItemStack:getItemTags() return self.child:getTags() end
function ItemStack:cloneItem() return self.child:clone() end
------------------------------ Object-Common Methods ------------------------------
function ItemStack:clone()
	return ItemStack(self:cloneItem(), self.amount, self.parent)
end

return ItemStack

--[[

add(its): 			Adds its to itself, if possible. Returns the added amount. (mutates it's arg)
take(n):  			Removes n from itself. Returns the removed amount.


Used for transferring between stacks.
	combine(its, n): If identical/possible, the caller(self) will take FROM the arg(its).			
		If n = nil; takes as much as possible.

Used for altering/modifying stacks:
I.e. Creating/Voiding items. E.g. crafting, trash cans, etc...			
	add(n): Adds the given amount to the stack,	
				If n = nil; add as much as possible (max out).
				Only up to <=maxStack. Returns the dif.
	sub(n):	Subtracts the given amount from the stack.
				If n = nil; remove as much as possible (reduce to zero).	
				Only down to >=0. Returns the dif.
						
		

--]]








