local MathUtils = {}

local function mapColor(min, max, nmin, nmax, ...)
	local c = type(...) == "table" and ... or {...}
	local rc = {}
	for i = 1, 4 do
		local v = c[i] or max
		rc[i] = MathUtils.map(v, min, max, nmin, nmax)
	end
	return rc
end

--- @param #color ... Either a table {r, g, b, a}, or direct r, g, b, a values.
-- 						Missing values default to 255
-- @return #color It's input mapped from [0, 255] to [0, 1].
function MathUtils.toLoveColor(...)
	return mapColor(0, 255, 0, 1, ...)
end

--- @param #color ... Either a table {r, g, b, a}, or direct r, g, b, a values.
-- 						Missing values default to 1
-- @return #color It's input mapped to from [0, 1] to [0, 255].
function MathUtils.to8bitColor(...)
	return mapColor(0, 1, 0, 255, ...)
end

function MathUtils.map(x, min, max, nmin, nmax)
 return (x - min) * (nmax - nmin) / (max - min) + nmin
end

return MathUtils