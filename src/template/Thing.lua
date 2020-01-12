local class = require "libs.cruxclass"
local Registry = require "istats.Registry"

local Thing = class("Thing")
function Thing:init(id)
	self.id = id
	Registry:applyStats(id, self)
end

function Thing:getId() return self.id end

function Thing:getName() return Registry:getName(self.id) end
function Thing:getDesc() return Registry:getDesc(self.id) end

function Thing:idEquals(o)  
	return type(o) == 'table' and self.id == o.id
end

function Thing:__tostring()
	return string:format("[%s] with ID: %s", 
		self.class.__name__, self.id)
end 

return Thing
