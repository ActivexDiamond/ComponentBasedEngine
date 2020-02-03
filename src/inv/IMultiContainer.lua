local Mixins = require "libs.Mixins"

------------------------------ Setup ------------------------------
local IMultiContainer = Mixins("IMultiContainer")
function IMultiContainer:__postInit()
	self:_onUpdate()
end

------------------------------ API ------------------------------
function IMultiContainer:combine(...)
	self:_onUpdate()
end 

function IMultiContainer:add(...)
	self:_onUpdate()
end

function IMultiContainer:sub(...)
	self:_onUpdate()
end

------------------------------ Callbacks ------------------------------
function IMultiContainer:_onUpdate() 
	if self.parent then self.parent:_onChildUpdate(self) end
	if self.children then 
		self:applyOnChildren(function(k, v) v:_onParentUpdate() end)
	end
end

function IMultiContainer:_onChildUpdate(child) 

end

function IMultiContainer:_onParentUpdate() 

end

------------------------------ Utils ------------------------------
function IMultiContainer:applyOnChildren(f)
	for k, v in ipairs(self.children or {}) do
		local rtVal = f(k, v)
		if rtVal then return rtVal end
	end
end

------------------------------ Getters/Setters ------------------------------
function IMultiContainer:getParent() return self.parent end
function IMultiContainer:_setParent(p)
	self.parent = p	
end

------------------------------ Child Getters/Setters ------------------------------
function IMultiContainer:getChildren() return self.children end
function IMultiContainer:getChild(i) return self.children[i] end

function IMultiContainer:_setChildren(c)
	if c.instanceof then c = {c} end
	self:applyOnChildren(function(k, v) v:_setParent(nil) end)
	self.children = c
	if c then self:applyOnChildren(function(k, v) v:_setParent(self) end) end
end

function IMultiContainer:_setChild(i, c)
	if self.children[i] then self.children[i]:_setParent(nil) end
	if c then c:_setParent(self) end
	self.children[i]  = c
end

function IMultiContainer:_addChild(c)
	if c then
		c:_setParent(self)
		self.children[#self.children] = c
	end	
end

---Takes an index-to-use or child-to-find.
function IMultiContainer:_removeChild(c)
	if type(c) == 'number' then
		local child =  table.remove(self.children, c)
		if child then
			child:_setParent(nil)
			return child
		end
	else --obj
		self:applyOnChildren(function(k, v)
			if v == c then
				local child = table.remove(self.children, k)
				child:_setParent(nil)
				return child
			end
		end)
	end
end
return IMultiContainer


--[[


child / self / parent

combine / add / sub

emptiable

get/set child/parent

get/set content 



--]]

--[[
local function cleanupArgs(from) end
local function combineItemStack(its, n) end
local function combineSlot(slot, n) end
local function combineInventory(inv, n) end


local function combine(from, n)
	return utils.ovld({from, n},		--args
			{cleanupArgs},			--optional cleanup function[1]
			combineItemStack, {ItemStack},
			combineSlot, {Slot},
			combineInventory, {Inventory}
		)


end


[1] The clean up function, if present, is used as follows:
{cleanup, nx, ny, ... } cleans up the provided args, for the function before it.
			If no numbers are provided, cleans up all args.
			
			If applied after the initial args - cleans up all functions.
			A mixture of general and function-specific cleanup may be used.
			
syntax:
utils.ovld({args} {allCleanupF, applyToArgN, ...},
		f1 {arg-types}, {f1CleanupF, applyToArgN, ...},
		f2 {arg-types}, {f2CleanupF, applyToArgN, ...},
		f3 {arg-types}, {f3CleanupF, applyToArgN, ...},
		...

Note: an empty arg-types tables is called if all args are nil.
Note: Arg-order is preserved, each arg is only checked against it's position in
		the provided overloads.
Note: allCleanupF is applied to all args before anything else is done.

args types:
	string	=	s
	number	=	n
	function=	f
	table	=	t
	nil		=	ni
	thread	=	th
	userdata=	u
	class	=	Class
	
	strict	=	-s		
	minimal	=	-m


Notes:
	- Functions are checked in order, the first matching one is called.
	- By default once all args for a function are found, it is called, 
		passed the founds args, followed by any 'more' arguments come after them.
			(common-args)
	- Minimal does the same as above but does not pass the function common-args.
	- Strict only calls a function if it's args match the base-args,
		aka if no common-args are present.
--]]

