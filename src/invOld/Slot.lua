local class = require "libs.cruxclass"
local Filter = require "inv.Filter"
local ItemStack = require "inv.ItemStack"

------------------------------ Helper Methods ------------------------------

------------------------------ Constructor ------------------------------
local Slot = class("Slot")
function Slot:init(inFilter, outFilter, itemStack, parent)
	self.inFilter = inFilter or Filter()
	self.outFilter = outFilter or Filter()
	self.its = itemStack or ItemStack()
	itemStack:setParent(self)
	self.parent = parent		--Inv, or nil.
end

------------------------------ Access Methods ------------------------------
function Slot:combine(from, n)
	if self:mayCombine(from, n) then
		if from:instanceof(Slot) and from:mayBeCombined(self, n) then
			return self.itemStack:combine(from:getItemStack(), n)
		else return self.itemStack:combine(from, n) end
	end
end

function Slot:add(n)
	if self:mayAdd(n) then
		return self.itemStack:add(n)
	end
end

function Slot:sub(n)
	if self:maySub(n) then
		return self.itemStack:sub(n)
	end
end
------------------------------ Direct Access Methods ------------------------------

--function Slot:directAdd(n)
--	return self.itemStack:add(n)
--end
--
--function Slot:directSub(n)
--	return self.itemStack:sub(n)
--end
------------------------------ Filter-Related Methods ------------------------------
function Slot:mayCombine(from, n)
	return self.inFilter:check(from, n)
end

function Slot:mayAdd(n)
	return self.inFilter:check(self, n)
end

function Slot:maySub(n)
	return self.outFilter:check(self, n)
end

------------------------------ Internals ------------------------------
function Slot:_onUpdate()

end


function Slot:_onChildUpdate()
	
end

function Slot:_constrainToMax(n)
	local cap = self:getCapacity()											
	return math.min(n or cap, cap)				
end

function Slot:_constrainToMin(n)
	return math.min(n or self.amount, self.amount)				
end
------------------------------ Getters / Setters ------------------------------
function Slot:getinFilter() return self.inFilter end
function Slot:getoutFilter() return self.outFilter end
function Slot:getItemSack() return self.itemStack end
function Slot:getParent() return self.parent end

function Slot:setinFilter(f) self.inFilter = f or Filter() end
function Slot:setoutFilter(f) self.outFilter = f or Filter() end
function Slot:setItemStack(its) 
	self.itemStack:setParent(nil)
	self.itemStack = its 
	self.itemStack:setParent(self)
	self:_onUpdte()
end
function Slot:setParent(p) 
	self.parent = p 
	self.parent:_onChildUpdate()
end

------------------------------ Object-Common Methods ------------------------------
function Slot:clone()
	return Slot(self.filter:clone(), self.its:clone(), self.parent)
end

return Slot

--[[

function Slot:combine(from, n)
	local cap = self.its:getCapacity()					
	if not self:mayAdd(from)then return 0 end			
	
	if from:instanceof(Slot) then						
		local n = n or from:getItemStack():getAmount()	
		local took = from:sub(math.min(cap, n))				
		if took <= 0 then return 0 end					
		return self.its:add(took)						
	else												
		local n = n or from:getAmount()					
		local took = from:sub(math.min(cap, n))			
		return self.its:add(took) end					
end

function Slot:combine(from, n)
	local from = self:mayCombine(from, n)				
	if not from then return 0 end						
	
	n = n or self:getCapacity()							
	if from:instanceof(Slot) then						
		local took = from:directSub(n)
		self:directAdd
	else												
	
	end
end

function Slot:add(n)
	if self:canAdd() then
		return self.its:add(its, n)
	end
end

function Slot:take(n)
	if self.canTake(n) then
		local dif = self.its:take(n)
		if self.its.amount <= 0 then 
			self.its:setParent(nil) 
			self.its = nil
		end
		return dif
	end
end


--]]