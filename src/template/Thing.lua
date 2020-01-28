local class = require "libs.cruxclass"
local Registry = require "istats.Registry"

------------------------------ Constructor ------------------------------
local Thing = class("Thing")
function Thing:init(id)
	self.id = id
	Registry:apply(id, self)
end

------------------------------ Abstract Methods ------------------------------
function Thing:draw(g) error "Abstract method Thing:draw(g) must be implemented in child!"  end

------------------------------ Getters ------------------------------
function Thing:getId() return self.id end

------------------------------ Registry Getters ------------------------------
function Thing:getName() return Registry:getName(self.id) end
function Thing:getDesc() return Registry:getDesc(self.id) end

function Thing:idEquals(o)  
	return type(o) == 'table' and self.id == o.id
end

function Thing:__tostring()
	return string.format("[%s] with ID: %s", 
		self.class.__name__, self.id)
end 

return Thing
