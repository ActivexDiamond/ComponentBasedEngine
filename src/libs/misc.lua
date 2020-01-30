
local misc = {}

------------------------------ Color Mapping ------------------------------
local function mapColor(min, max, nmin, nmax, ...)
	local c = type(...) == "table" and ... or {...}
	local rc = {}
	for i = 1, 4 do
		local v = c[i] or max
		rc[i] = misc.map(v, min, max, nmin, nmax)
	end
	return rc
end

--- @param #color ... Either a table {r, g, b, a}, or direct r, g, b, a values.
-- 						Missing values default to 255
-- @return #color It's input mapped from [0, 255] to [0, 1].
function misc.toLoveColor(...)
	return mapColor(0, 255, 0, 1, ...)
end

--- @param #color ... Either a table {r, g, b, a}, or direct r, g, b, a values.
-- 						Missing values default to 1
-- @return #color It's input mapped to from [0, 1] to [0, 255].
function misc.to8bitColor(...)
	return mapColor(0, 1, 0, 255, ...)
end

------------------------------ Misc Math ------------------------------
function misc.map(x, min, max, nmin, nmax)
 return (x - min) * (nmax - nmin) / (max - min) + nmin
end

function misc.constrain(x, min, max)
	return math.max(math.min(x, max), min)
end

------------------------------ Conversion Methods ------------------------------
function misc.toBin(n, bits, seg, space, sep) 
	local t, s, nb = {}, seg
	local space = space or ' ' 
	if n == 0 then nb = 1
	else nb = math.floor(math.log(n) / math.log(2)) + 1 end		--neededBits = roundUp(log2(n))

	for b = nb, 1, -1 do
		local rest = math.fmod(n, 2)
		table.insert(t, 1, rest)
		if seg then
			s = s - 1
			if s == 0 then table.insert(t, 1, space) ; s = seg end
		end
		n = (n - rest) / 2
	end
	
	if bits and bits > nb then 
		for i = 1, bits - nb do 
			table.insert(t, 1, '0') 
			if seg then
				s = s - 1
				if s == 0 then table.insert(t, 1, space) ; s = seg end
			end
		end
	end
		
	return table.concat(t, sep)
end

------------------------------ Lua-Related ------------------------------
function misc.overload(t, ...)			--selectArg(type, args)
	local i, p = 1, tonumber(t:sub(1, 1))
	if type(p) == 'number' then
		i, t = p, t:sub(2, -1)
	end
	
	if t == 's' then t = 'string'
	elseif t == 'n' then t = 'number'
	elseif t == 'f' then t = 'function'
	elseif t == 't' then t = 'table'
	elseif t == 'ni' then t = 'nil'
	elseif t == 'th' then t = 'thread'
	elseif t == 'u' then t = 'userdata' end
	for k, v in ipairs({...}) do
		if type(v) == t then i = i - 1; if i == 0 then return v end end
	end
end

return misc