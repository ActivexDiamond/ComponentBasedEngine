local class = require "libs.cruxclass"

------------------------------ Helper Methods ------------------------------

------------------------------ Constructor ------------------------------
local Slot = class("Slot")
function Slot:init(filter, itemStack, parent)
	self.filter = filter
	self.its = itemStack
	itemStack:setParent(self)
	self.parent = parent		--Inv, or nil.
end

------------------------------ Main Methods ------------------------------
function Slot:add(its, n)
	if self.filter:canAdd(self, its, n) then
		return self.its:add(its, n)
	end
end

function Slot:take(n)
	if self.filter:canTake(self, n) then
		local dif = self.its:take(n)
		if self.its.amount <= 0 then 
			self.its:setParent(nil) 
			self.its = nil
		end
		return dif
	end
end

------------------------------ Getters / Setters ------------------------------
function Slot:getFilter() return self.filter end
function Slot:getItemSack() return self.itemStack end
function Slot:getParent() return self.parent end

function Slot:setFilter(f) self.filter = f end
function Slot:setItemStack(its) self.itemStack = its end
function Slot:setParent(p) self.parent = p end

------------------------------ Object-Common Methods ------------------------------
function Slot:clone()
	return Slot(self.filter:clone(), self.its:clone(), self.parent)
end

return Slot