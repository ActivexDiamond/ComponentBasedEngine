local class = require "libs.cruxclass"
local Entity = require "template.Entity"

------------------------------ Helper Methods ------------------------------

------------------------------ Constructor ------------------------------
local ItemDrop = class("ItemDrop", Entity)
function ItemDrop:init(id, x, y)
	Entity.init(self, id, x, y)
end

------------------------------ Getters / Setters ------------------------------

return ItemDrop