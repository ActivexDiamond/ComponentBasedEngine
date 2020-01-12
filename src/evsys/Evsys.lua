local class = require "libs.cruxclass"
local Event = require "evsys.Event"

--local Game = require "core.Game"
--local Registry = require "istats.Registry"

local Evsys = class("Evsys")
function Evsys:init()	--@Singletone
	self.evs = {}
	self.q = {}
end

function Evsys:lockOn(class)
	self.lock = class
end

function Evsys:attach(e, f)	
	assert(e:subclassof(Event) or e == Event, "May only attach Event or a subclass of it.")
	assert(type(f) == 'function', "Callback must be a function.")

	if not self.evs[e] then self.evs[e] = {} end	--If first time attaching to Event e, create table for it.
	if not self.evs[e][self.lock] then 				--If first time attaching this class to said event, craete a table for it. 
		self.evs[e][self.lock] = {f = {}, i = {}}
	end 
	table.insert(self.evs[e][self.lock].f, f) 
end

function Evsys:subscribe(inst)
	for _, v in pairs(self.evs) do
		if v[inst.class] then
			table.insert(v[inst.class].i, inst)
		end		
	end
end

function Evsys:queue(e)
	assert(e.instanceof and e:instanceof(Event), "May only queue Event or a subclass of it.")
	table.insert(self.q, e)
end


local function fire(self, e)
	for _, class in pairs(self.evs[e.class] or {}) do
		for _, inst in pairs(class.i) do
			for _, f in pairs(class.f) do f(inst, e) end
		end
	end
end

function Evsys:poll()
	while #self.q > 0 do
		fire(self, self.q[1])
		table.remove(self.q, 1)
	end
end

return Evsys()
