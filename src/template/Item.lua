local class = require "libs.cruxclass"
local Thing = require "template.Thing"

local IContainable = require "inv.IContainable"
local IGuiIcon = require "gui.IGuiIcon"
------------------------------ Helper Methods ------------------------------

------------------------------ Constructor ------------------------------
local Item = class("Item", Thing):include(IContainable, IGuiIcon)
function Item:init(id, parent)
	Thing.init(self, id)
	self.parent = parent
end

------------------------------ Constants ------------------------------
Item.TINY, Item.SMALL, Item.MEDIUM, Item.LARGE, Item.HUGE = 1, 2, 3, 4, 5

------------------------------ API ------------------------------


------------------------------ Utils ------------------------------
function Item:cloneTags() return utils.t.clone(self:getTags()) end

------------------------------ Object-Common Methods ------------------------------
function Item:equals(item)
	if item and item.instanceof and item:instanceof(Item) then
		return self.id == item.id
	end 
end

function Item:clone()
	return Item(self.id)
end

return Item