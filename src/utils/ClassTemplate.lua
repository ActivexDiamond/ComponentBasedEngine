------------------------------ Obj + Super ------------------------------
local class = require "libs.cruxclass"
local Super = require "x"

local Object = class("Unnamed", Super)
function Object:init()
	Super.init(self)
end

return Object

------------------------------ Obj ------------------------------
local class = require "libs.cruxclass"

local Object = class("Unnamed")
function Object:init()
end

return Object

------------------------------ Obj + Thing ------------------------------
local class = require "libs.cruxclass"
local Thing = require "template.Thing"

local Object = class("Unnamed", Thing)
function Object:init(id)
	Thing.init(self, id)
end

return Object