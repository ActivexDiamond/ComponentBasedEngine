local class = require "libs.cruxclass"
local WorldObj = require "template.WorldObj"
local Game = require "core.Game"
--local Registry = require "istats.Registry"


local Block = class("Block", WorldObj)
function Block:init(id, x, y)
	WorldObj.init(self, id, Game:snap(x), Game:snap(y), 'static')	
end

---Overrides - Position Snapping
function Block:setX(x) WorldObj.setX(Game:snap(x)) end
function Block:setY(y) WorldObj.setY(Game:snap(y)) end
function Block:setPos(x, y) self:setX(x); self:setY(y) end

--TODO: Perhaps override dimension-setters to also snap?

return Block