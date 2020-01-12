local class = require "libs.cruxclass"
local Event = require "evsys.Event"

local KeypresedEvent = class("KeypresedEvent", Event)
function KeypresedEvent:init(k)
	self.k = k
end

return KeypresedEvent
