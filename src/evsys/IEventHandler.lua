local Mixins = require "libs.Mixins"
local Evsys = require "evsys.Evsys"

local IEventHandler = Mixins("IEventHandler")

---Setup
function IEventHandler:__included(class)
	Evsys:lockOn(class)
end

function IEventHandler:__postInit()
	if DEBUG.EVENT_SUBS then print(string.format("%s\t Subscribed to the evsys.", self)) end
	Evsys:subscribe(self)
end

---Methods
function IEventHandler:attach(e, f)
	if DEBUG.EVENT_ATTACHES then 
		print(string.format("[%s] attached [%s] to [%s].", self, f, e.__name__)) 
	end
	Evsys:attach(e, f)
end

return IEventHandler


