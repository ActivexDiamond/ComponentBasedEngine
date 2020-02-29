local class = require "libs.cruxclass"
local Item = require "template.Item"

local Filter = require "inv.Filter"
local ItemStack = require "inv.ItemStack"
local IContainer = require "inv.IContainer"
local IGuiElement = require "gui.IGuiElement"

------------------------------ Helper Methods ------------------------------

------------------------------ Constructor ------------------------------
local Slot = class("Slot"):include(IContainer, IGuiElement)
function Slot:init(t)
	t = t or {}
	self.inFilter = t.inFilter or Filter()
	self.outFilter = t.outFilter or Filter()
	self.noBg, self.noHit = t.noBg, t.noHit 
	self:setItemStack(t.itemStack)
	self:_setParent(t.parent)			--Inv, or nil.
	print(self:getItemStack() and self:getItemStack():getItem())
end

------------------------------ GUI Methods ------------------------------
function Slot:tickGui(gui, pos, index)
	--draw item
	local x, y = pos.x + self.gui.padX, pos.y + self.gui.padY
	if self.child then
		local n = self.child:getAmount()
		if n > 1 then
			local txtH = love.graphics.getFont():getHeight()
			gui:TextSign(n, x, y + pos.h - txtH)
		end
		self.child:getItem():tickGui(gui, pos)
	end
	
	--draw slot		
	--TODO: Seperate bg and hit check. 
	if not self.noBg and not self.noHit then
		local hit = gui:Button("", {id = index}, pos()).hit
		if self.parent and hit then 
			if hit == 1 then self.parent:_onChildUpdate(self, 'LMB', index) end
			if hit == 2 then self.parent:_onChildUpdate(self, 'RMB', index) end
			 
		end
	end
end

------------------------------ Access Methods ------------------------------
local function combineItemStack(self, its, n)
	if DEBUG.INV_DETAILS then print("combineItemStack", self, its, n) end
	if not self:mayCombine(its, n) then return -1 end
	if self.child then
		n = self:_constrainToMax(n)
		if DEBUG.INV_DETAILS then print('self.child.child', self.child.child, 'its.child', its.child) end
		return self.child:combine(its, n)
	else
		if DEBUG.INV_DETAILS then print('if not self.child') end
		local cap = self:getCapacity(its)
		local a = its:getAmount()
		n = its:_constrainToMin(n)
		if n == a and cap >= a then
			its:_setParent(nil)
			self:_setChild(its)
			if DEBUG.INV_DETAILS then print('a', a) end
			return a
		else
			local dif = its:sub(n)
			self:_setChild( ItemStack(its:cloneItem(), dif) )
			if DEBUG.INV_DETAILS then print('dif', dif) end
			return dif
		end		
	end
end

local function combineSlot(self, slot, n)
	if DEBUG.INV_DETAILS then print("combineSlot", self, slot, n) end
	if slot:mayBeCombined(self, n) then
		return combineItemStack(self, slot:getItemStack(), n)
	end
end

function Slot:combine(from, n)
	if DEBUG.INV_DETAILS then print("combine", from, n) end
--	return utils.ovld({from, n, self},
	return utils.ovld({self, from, n},
			combineItemStack, {ItemStack},
			combineSlot, {Slot}
	)
end

function Slot:add(n)
	if self:mayAdd(n) then
		return self.child:add(n)
	end
end

function Slot:sub(n)
	if self:maySub(n) then
		return self.child:sub(n)
	end
end
------------------------------ Callbacks ------------------------------
function Slot:_onChildUpdate()
	if self.child and self.child:getAmount() == 0 then
		self:_setChild(nil)
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


function Slot:mayBeCombined(into, n)
	return self.outFilter:check(into, n)
end

function Slot:mayAdd(n)
	if self.child then
		return self.inFilter:check(self, n)
	else return false end
end

function Slot:maySub(n)
	if self.child then
		return self.outFilter:check(self, n)
	else return false end
end

------------------------------ Internals ------------------------------
function Slot:_constrainToMax(n)
	local cap = self:getCapacity()											
	return math.min(n or cap, cap)				
end

--function Slot:_constrainToMin(n)
--	return math.min(n or self.amount, self.amount)				
--end
------------------------------ Getters / Setters ------------------------------
local function getCapItem(item) return item:getMaxStack() end
local function getCapItemStack(its) return its.child:getMaxStack() end
local function getCap(self) 	
	return self.child and (self.child.child:getMaxStack() - self.child:getAmount())
end

function Slot:getCapacity(source)
	return (utils.ovld({nil, source, nil, self, nil},
--	return (utils.ovld({self, source, 1},
			getCapItem, {Item},
			getCapItemStack, {ItemStack},
			getCap, {self}
	))-- or 0
end

function Slot:getInFilter() return self.inFilter end
function Slot:getOutFilter() return self.outFilter end
function Slot:getItemStack() return self:getChild() end

function Slot:setInFilter(f) self.inFilter = f or Filter() end
function Slot:setOutFilter(f) self.outFilter = f or Filter() end
function Slot:setItemStack(its) 
	self:_setChild(its)
end

------------------------------ Util-Getters (For Quick Access) ------------------------------

------------------------------ Object-Common Methods ------------------------------
function Slot:clone()
	return Slot(self.inFilter:clone(), self.outFilter:clone(), self.child:clone(), self.parent)
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