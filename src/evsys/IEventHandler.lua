local Mixins = require "libs.Mixins"
local Evsys = require "evsys.Evsys"

local IEventHandler = {}

---Setup
function IEventHandler:__included(class)
	print('__inc', self, class)
	Evsys:lockOn(class)
end

Mixins.onPostInit(IEventHandler, function(self)
	print 'x'
	Evsys:subscribe(self)
end)

---Methods
function IEventHandler:attach(e, f)
	print 'y'
	Evsys:attach(e, f)
end

return IEventHandler


