local class = require "libs.cruxclass"

local Keybinds = class("Keybinds")
function Keybinds:init(k, code, rpt)
	error "Cannot instantise static class."
end

Keybinds.UP = 'w'
Keybinds.DOWN = 's'
Keybinds.LEFT = 'a'
Keybinds.RIGHT = 'd'

Keybinds.JUMP = 'space'

return Keybinds
