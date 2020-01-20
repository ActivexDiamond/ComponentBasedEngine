local class = require "libs.cruxclass"

------------------------------ Helper Methods ------------------------------
local getTime = love.timer.getTime
local ins = table.insert
local rem = table.remove
local modf = math.modf

local function execute(dt, func, args)
	func(dt, type(args) ~= 'table' and args or unpack(args))
end

local function executeWrapup(func, args)
	func(type(args) ~= 'table' and args or unpack(args))
end

local function remove(t, i)
	executeWrapup(t.wrapup[i], t.wargs[i])
	rem(t.wait,     i)
	rem(t.interval, i)
	rem(t.timeout,  i)
	rem(t.stamp,    i)
	rem(t.flag,     i)
	rem(t.last,     i)
	rem(t.func,     i)
	rem(t.args,     i)
	rem(t.wrapup,   i)
	rem(t.wargs,    i)
end

local function process(t, dt, i, wait, interval, timeout, stamp, flag, last, func, args)
	local time = getTime()
	
	if time >= stamp + wait then								--If (at or post 'wait'); proceed 
		if interval == 0 then									--	If 'interval' == 0; single execution
			execute(time - stamp, func, args)					--		Execute once; 'fdt' = time since initial scheduling
			return true											--		Yield
		elseif timeout == 0 or time <= stamp + timeout then		--	If (no timeout is set) or (within timeout); proceed
			if interval == -1 then								--		If interval == -1; execute every tick
				local fdt = flag == 0 and dt or time - stamp	--			'fdt' = (first run) ? tick-dt : time since initial scheduling 
				t.flag[i] = 0									--			Set 'first run' flag
				execute(fdt, func, args)						--			Execute
			else												--		If 'interval' set (not 0 and not -1); execute every 'interval' for 'timeout'
				local fdt, dif, reruns							--			[1]elaborated below
				if flag == -1 then								--
					fdt = time - stamp							--
					dif = time - stamp - wait					--
				else											--
					fdt = time - last							--
					dif = time - flag							--
				end												--
																--
				reruns, dif = modf(dif / interval)				--
				if flag == -1 then reruns = reruns + 1 end		--
																--
				for i = 1, reruns do							--
					execute(i == 1 and fdt or 0, func, args)	--
					if i + 1 == reruns then flag = time end		--
				end												--
																--
				t.last[i] = flag								--
				t.flag[i] = flag - dif							--
			end													--
		else return true end									--	If timed out; yield
	end
end

--[[
Execution:
once at or post 'wait':
	if interval == 0 -> execute then remove; //dt equals time - stamp  
	elseif interval == -1
		if timeout == 0 or within timeout, execute;	//dt if first time equals time - stamp
		else remove;								//else equals tick dt
		(repeat the above 'if' once every tick)
	else;
		execute every INTERVAL for TIMEOUT ; 
		if ticks took longer than INTERVAL -> execute multiple times per tick
		[1][elaborated below]

[1]
if timed out; yield
if flag == -1
	fdt = time - stamp
	dif = time - stamp - wait
else
	fdt = time - last
	dif = time - flag
	
reruns, dif = math.modf(dif / interval)
if flag == -1 then reruns++ end

for i = 1, reruns do
	execute(i == 1 and fdt or 0)		--if multiple executions in a row, the first is passed dt the rest are passed 0
	if i + 1 == reruns then flag = time end
end
last = flag
flag = flag - dif

[2] examples
stamp = 30
wait = 5
interval = 1
flag = -1

------------ first run [time = 35.3] //since stamp = 5.3	;	since first run 0.3
fdt = 5.3
dif = 0.3
	reruns, dif = 0++, 0.3 [0.3 / 1 ; ++]
	
flag = 35.0

------------ second run [time = 36.8] //since stamp = 6.8	;	since first run 1.8
fdt = 1.8
dif 1.8
	reruns, dif = 1, 0.8 [1.8 / 1]
	
flag = 36.0

------------ third run [time = 38.3] //since stamp = 8.3	;	since first run 3.3
fdt = 1.8
dif = 2.3
	reruns, dif = 2, 0.3 [2.3 / 1]

flag = 38.0

------------ fourth run [time = 39.8] //since stamp = 9.8	;	since first run 4.8
fdt = 1.8
dif 1.8
	reruns, dif = 1, 0.8 [1.8 / 1]
	
flag = 39.0	
--]]
------------------------------ Constructor ------------------------------
local Scheduler = class("Scheduler")
function Scheduler:init()
	self.tasks = {wait = {}, interval = {}, timeout = {}, stamp = {}, 
		flag = {}, last = {}, func = {}, args = {}, wrapup = {}, wargs = {}}
end

------------------------------ Main Methods ------------------------------
function Scheduler:tick(dt)
--	local time = getTime()
	local yielded = {}
	local t = self.tasks
	for i = 1, #t.func do	--All subtables of self.tasks should always be of equal length.
		local done = process(t, dt, i, t.wait[i], t.interval[i], t.timeout[i], t.stamp[i], 
				t.flag[i], t.last[i], t.func[i], t.args[i])
		if done then ins(yielded, i) end
	end
		
	for i = 1, #yielded do	--Remove yielded entries in reverse order (so indices remain consistent during yielding)
		remove(t, yielded[#yielded + 1 - i])
	end
end

function Scheduler:schedule(wait, interval, timeout, stamp, func, args, wrapup, wargs)
	local t = self.tasks
	ins(t.wait,     wait     or 0)
	ins(t.interval, interval or 0)
	ins(t.timeout,  timeout  or 0)
	ins(t.stamp,    stamp    or getTime())
	ins(t.flag,     -1)
	ins(t.last,     -1)
	ins(t.func,     func)
	ins(t.args,     args     or {})
	ins(t.wrapup,   wrapup)
	ins(t.wargs,    wargs    or {})
end

------------------------------ Schedule Methods ------------------------------
function Scheduler:callAfter(wait, func, args, wrapup, wargs)
	self:schedule(wait, nil, nil, nil, func, args, wrapup, wargs)
end

function Scheduler:callFor(timeout, func, args, wrapup, wargs)
	self:schedule(nil, -1, timeout, nil, func, args, wrapup, wargs)
end

function Scheduler:callEvery(interval, func, args, wrapup, wargs)
	self:schedule(nil, interval, nil, nil, func, args, wrapup, wargs)
end

function Scheduler:callEveryFor(interval, timeout, func, args, wrapup, wargs)
	self:schedule(nil, interval, timeout, nil, func, args, wrapup, wargs)
end
return Scheduler()
