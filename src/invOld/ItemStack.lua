local class = require "libs.cruxclass"
local Item = require "template.Item"

------------------------------ Helper Methods ------------------------------

------------------------------ Constructor ------------------------------
local ItemStack = class("ItemStack")
function ItemStack:init(item, amount, parent)
	self.item = item
	self.amount = amount or self.DEFAULT_AMOUNT
	self.parent = parent		--Slot, ItemDrop, or nil.

	if item then self.item:setParent(self) end
	self:_onUpdate()
end

------------------------------ Constants ------------------------------
ItemStack.DEFAULT_AMOUNT = 1
 
------------------------------ Access Methods ------------------------------

function ItemStack:combine(its, n)
	if not self.item or self.item:equals(its:getItem()) then 	
		n = self:_constrainToMax()
		local dif = its:sub(n)
		if self.item then self:setItem(its.getItem())											
		return self:add(its:sub(n))
	end
	
	n = self:_constrainToMax()
	if not self.item then
		local item = its:getItem()
		local dif = its:sub(n)
		if dif > 0 then self:setItem(item); self:add(n) end 
		return dif
	elseif self.item:equals(its:getItem()) then
		local dif = its:sub(n)
		if dif > 0 then self:add(n) end 
		return dif
	end
end

nil neq	= itm and eq
nil eq  = itm and neq
itm neq
itm eq


function ItemStack:add(n)
	if not self.item then return 0 end
	n = self:_constrainToMax(n)
	self.amount = self.amount + n
	self:_onUpdate()
	return self.amount - n 
end

function ItemStack:sub(n)
	if not self.item then return 0 end
	n = self:_constrainToMin(n)
	self.amount = self.amount - n
	self:_onUpdate()
	return self.amount + n
end

------------------------------ Internals ------------------------------
function ItemStack:_onUpdate()
	if self.item then
		self.mass = self.item:getMass() * self.amount
		if self.amount == 0 then 
			self.item:setParent(nil)
			self.item = nil 
		end
	end
	if self.parent then self.parent:_onChildUpdate() end
end

function ItemStack:_onChildUpdate()

end

function ItemStack:_constrainToMax(n)
	local cap = self:getCapacity()											
	return math.min(n or cap, cap)				
end

function ItemStack:_constrainToMin(n)
	return math.min(n or self.amount, self.amount)				
end
------------------------------ Getters / Setters ------------------------------
function ItemStack:getCapacity() return self.item:getMaxStack() - self.amount end

function ItemStack:getItem() return self.item end
function ItemStack:getAmount() return self.amount end
function ItemStack:getMass() return self.mass end
function ItemStack:getParent() return self.parent end

function ItemStack:setItem(itm) 
	self.item:setParent(nil)
	self.item = itm
	self.item:setParent(self)
	self:_onUpdate() 
end
function ItemStack:setAmount(a) 
	self.amount = a
	self:_onUpdate() 
end
function ItemStack:setParent(p) 
	self.parent = p 
	self.parent:_onChildUpdate()
end

function ItemStack:setContents(i, amount)	--Also takes an ItemStack
	if i:instanceof(ItemStack) then
		self:setItem(i:getItem():clone())
		self:setAmount(i:getAmount())
	elseif i:instanceof(Item) then
		self:setItem(i)
		self.item = i
		self.amount = amount or self.DEFAULT_AMOUNT
	else error "Can only take either an ItemStack, or Item and amount(default = 1)." end
	self:_onUpdate()
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








