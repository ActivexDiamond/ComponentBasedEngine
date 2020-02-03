local class = require "libs.cruxclass"

------------------------------ Helper Methods ------------------------------
local function formatArg(arg)
	local t = type(arg)
	if t == "table" or t == "nil" then return t
	else return {t} end
end

------------------------------ Constructor ------------------------------
local Filter = class("Filter")
function Filter:init(items, sizes, tags, nItems, nSizes, nTags)
	self.items = formatArg(items) or Filter._DEFAULT_WHITE
	self.sizes = formatArg(sizes) or Filter._DEFAULT_WHITE
	self.tags = formatArg(tags) or Filter._DEFAULT_WHITE
	
	self.nItems = formatArg(nItems) or Filter._DEFAULT_BLACK
	self.nSizes = formatArg(nSizes) or Filter._DEFAULT_BLACK
	self.nTags = formatArg(nTags) or Filter._DEFAULT_BLACK
end

------------------------------ Constants ------------------------------
Filter.ALL = 0					--Must not equal any of Item.SIZES
Filter.NONE = -1				--Must not equal any of Item.SIZES

Filter._DEFAULT_WHITE = Filter.ALL
Filter._DEFAULT_BLACK = Filter.NONE

------------------------------ API ------------------------------

------------------------------ Getters/Setters ------------------------------

------------------------------ Factories ------------------------------
function Filter:fWhitelist(items, sizes, tags)
	return Filter(items, sizes, tags)
end

function Filter:fBlacklist(nItems, nSizes, nTags)
	return Filter(nil, nil, nil, nItems, nSizes, nTags)
end

function Filter:fItems(items, nItems)
	return Filter(items, nil, nil, nItems, nil, nil)
end

function Filter:fSizes(sizes, nSizes)
	return Filter(nil, sizes, nil, nil, nSizes, nil)
end

function Filter:fTags(tags, nTags)
	return Filter(nil, nil, tags, nil, nil, nTags)
end

------------------------------ Utils ------------------------------

------------------------------ Object-Common Methods ------------------------------
function Filter:clone()
	return Filter(self.items, self.sizes, self.tags,
			self.Nitems, self.Sizes, self.nTags)	
end

return Filter

--[[
factories:
	fWhitelist(items, sizes, tags)
	fBlacklist(nItems, nSizes, nTags)

	fItems(items, nItems)
	fSizes(sizes, nSizes)
	fTags(tags, nTags)

origin				- s1 = 32	;	s2 = 48
s2:add(s1)			- s1 = 16	;	s2 = 64

origin				- s1 = 32	;	s2 = 48
s1 = s2:take()		- s1 = 64	;	s2 = 16 

origin				- s1 = 32	;	s2 = 48
s1 = s2:take(16)	- s1 = 48	;	s2 = 32

--]]



