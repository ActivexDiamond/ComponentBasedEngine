local class = require "libs.cruxclass"
local State = require "core.State"

---Constructor
local MultiState = class("MultiState", State)
function MultiState:init(initialState)
	State.init(self)
	self.state = {}
end

---Constants
MultiState.DEFAULT_VAL = false

---Main Methods
function MultiState:set(s, v)
	if type(v) == 'nil' then v = true end
	self.state[s], v = v, self.state[s]
	return self.state[s] ~= v
end

function MultiState:unset(s)
	return self:set(s, false)
end

function MultiState:get(s)
	return self.state[s]
end

---Util Methods
function MultiState:noneof(...)
	local all = {...}
	for _, v in ipairs(all) do
		if self.state[v] == true then return false end
	end
	return true
end

function MultiState:anyof(...)
	local all = {...}
	for _, v in ipairs(all) do
		if self.state[v] == true then return true end
	end
	return false
end

function MultiState:is(s)
	return self.state[s]
end

function MultiState:isnot(s)
	return not self.state[s]
end

return MultiState