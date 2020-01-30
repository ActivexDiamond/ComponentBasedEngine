local class = require "libs.cruxclass"
local Thing = require "template.Thing"

------------------------------ Helper Methods ------------------------------

------------------------------ Constructor ------------------------------
local Item = class("Item", Thing)
function Item:init(id, parent)
	Thing.init(self, id)
	self.parent = parent
end

------------------------------ Constants ------------------------------
Item.TINY, Item.SMALL, Item.MEDIUM, Item.LARGE, Item.HUGE = 1, 2, 3, 4, 5

------------------------------ API ------------------------------

------------------------------ Getters/Setters ------------------------------
function Item:getParent() return self.parent end

function Item:setParent(p) self.parent = p end

------------------------------ Utils ------------------------------
function Item:cloneTags() return utils.t.clone(self:getTags()) end

------------------------------ Object-Common Methods ------------------------------
function Item:clone()
	return Item(self.id)
end

return Item