local class = require "libs.cruxclass"
local WorldObj = require "template.WorldObj"
--local Game = require "core.Game"
--local Registry = require "istats.Registry"

local Entity = class("Entity", WorldObj)
function Entity:init(id, x, y)
	WorldObj.init(self, id, x, y, 'dynamic')	
end

return Entity