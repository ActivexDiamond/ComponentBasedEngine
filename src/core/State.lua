local class = require "libs.cruxclass"

---Constructor
local State = class("State")
function State:init(initialState)
	self.state = initialState or State.DEFAULT_INITIAL
end

---Constants
State.DEFAULT_MAX = 10
State.DEFAULT_INITIAL = 1
---Main Methods
function State:set(s)
	self.state, s = s, self.state
	return self.state == s
end

function State:get()
	return self.state
end

---Util Methods
function State:create(n)
	n = n or State.DEFAULT_MAX
	local t = {}
	for i = 1, n do
		t[i] = i
	end
	return unpack(t)
end

function State:noneof(...)
	local all = {...}
	for _, v in ipairs(all) do
		if self.state == v then return false end
	end
	return true
end

function State:anyof(...)
	local all = {...}
	for _, v in ipairs(all) do
		if self.state == v then return true end
	end
	return false
end

function State:is(s)
	return self.state == s
end

function State:isnot(s)
	return self.state ~= s
end

return State