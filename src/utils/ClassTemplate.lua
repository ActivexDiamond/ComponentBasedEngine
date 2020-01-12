local class = require "libs.cruxclass"
local Super = require "x"

local Object = class("Unnamed", Super)
function Object:init()
	Super.init(self)
end

return Object

-----------------------

local class = require "libs.cruxclass"

local Object = class("Unnamed")
function Object:init()
end

return Object