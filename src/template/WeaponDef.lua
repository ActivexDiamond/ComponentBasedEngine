local class = require "libs.cruxclass"

------------------------------ Constructor ------------------------------
local WeaponDef = class("WeaponDef")
function WeaponDef:init()
	error "Attempting to initialize static class."
end

------------------------------ Constants ------------------------------
WeaponDef.anchors = {}
WeaponDef.anchors.ORIGIN = 0
WeaponDef.anchors.CENTER = 1
WeaponDef.anchors.NATURAL = 2

WeaponDef.transitions = {}
WeaponDef.transitions.INSTANT = 10
WeaponDef.transitions.LINEAR_GROW = 11
return WeaponDef