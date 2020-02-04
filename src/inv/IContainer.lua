local Mixins = require "libs.Mixins"

------------------------------ Setup ------------------------------
local IContainer = Mixins("IContainer")
function IContainer:__postInit()
	self:_onUpdate()
end

------------------------------ API ------------------------------
function IContainer:combine(...)
	self:_onUpdate()
end 

function IContainer:add(...)
	self:_onUpdate()
end

function IContainer:sub(...)
	self:_onUpdate()
end

------------------------------ Callbacks ------------------------------
function IContainer:_onUpdate(...) 
	if self.parent then self.parent:_onChildUpdate(self) end
	if self.child then self.child:_onParentUpdate() end
end

function IContainer:_onChildUpdate(child, ...) 

end

function IContainer:_onParentUpdate(...) 

end

------------------------------ Getters/Setters ------------------------------
function IContainer:getParent() return self.parent end
function IContainer:_setParent(p)
	self.parent = p	
end

------------------------------ Child Getters/Setters ------------------------------
function IContainer:getChild() return self.child end

function IContainer:_setChild(c)
	if self.child then self.child:_setParent(nil) end
	if c then c:_setParent(self) end
	self.child = c
end

function IContainer:_removeChild()
	self:_setChild(nil)
end

return IContainer


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

