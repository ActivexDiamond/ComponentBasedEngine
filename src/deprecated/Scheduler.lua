local class = require "libs.cruxclass"

------------------------------ Helper Methods ------------------------------
local getTime = love.timer.getTime
local ins = table.insert
local rem = table.remove

local function push(t, wait, interval, timeout, stamp, funcs, args)
	
	for k, v in ipairs(t) do
		ins(t[k], args[k])
	end
end

------------------------------ Constructor ------------------------------
local Scheduler = class("Scheduler")
function Scheduler:init()
	self.after    = {wait     = {},               stamp = {}, func = {}, args = {}}
	self.ffor     = {timeout  = {},               stamp = {}, func = {}, args = {}}
	self.every    = {interval = {},               stamp = {}, func = {}, args = {}}
	self.everyFor = {interval = {}, timeout = {}, stamp = {}, func = {}, args = {}}
end

------------------------------ Main Methods ------------------------------
function Scheduler:tick(dt)
	
end

------------------------------ Schedule Methods ------------------------------
function Scheduler:callAfter(wait, func, ...)
	push(self.after, wait, getTime(), func, {...})
--	local t = self.after
--	ins(t.wait, wait)
--	ins(t.stamp, getTime())
--	ins(t.func, func)
--	ins(t.args, {...})
end

function Scheduler:callFor(timeout, func, ...)
	push(self.ffor, timeout, getTime(), func, {...})
end

function Scheduler:callEvery(interval, func, ...)

end

function Scheduler:callEveryFor(interval, timeout, func, ...)

end
return Scheduler()