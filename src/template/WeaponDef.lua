local class = require "libs.cruxclass"

local WeaponDef = class("WeaponDef")
function WeaponDef:init()
	error "Attempting to initialize static class."
end

WeaponDef.ORIGIN = 0
WeaponDef.CENTER = 1
WeaponDef.CENTER_ALIGNED = 2

WeaponDef.INSTANT = 10
WeaponDef.LINEAR_GROW = 11
return WeaponDef