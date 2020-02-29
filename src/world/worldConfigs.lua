local class = require "libs.cruxclass"

------------------------------ Helper Methods ------------------------------

------------------------------ Constructor ------------------------------
local WorldConfigs = class("WorldConfigs")
function WorldConfigs:init(t)
	--TODO: read-only classes. Their vars can be accessed directly since they're all final.
	--TODO: fetch defaults from the game's global defaults.
	t = t or {}
	self.name = t.name or "New World 42" --TODO: properly increment number.

	self.w = t.w or 2^16
	self.h = t.h or 2^16
	
	self.leftEdge 	= -t.w / 2
	self.rightEdge 	=  t.w / 2
	self.topEdge 	= -t.h / 2
	self.bottomEdge =  t.h / 2
	
	self.spawnPoint = t.spawnPoint or {0, 0}
	self.difficulty = t.difficulty or WorldConfigs.DIF_NORMAL
	
	self.gameRules = WorldConfigs.DEFAULT_GAME_RULES
	for rule, val in pairs(t.gameRules or {}) do
		self.gameRules[rule] = val
	end
	
	self.worldGenConfigs = WorldConfigs.DEFAULT_WORLD_GEN_CONFIGS
	for field, val in pairs(t.worldGenConfigs or {}) do
		self.gameRules[field] = val
	end
end

------------------------------ Constants ------------------------------
WorldConfigs.DIF_PEACEFUL = 0
WorldConfigs.DIF_EASY = 1
WorldConfigs.DIF_NORMAL = 2
WorldConfigs.DIF_HARD = 3
WorldConfigs.DIF_QUITE_HARD = 4

WorldConfigs.DEFAULT_GAME_RULES = {
	--TODO: Come up with some.
}

WorldConfigs.DEFAULT_WORLD_GEN_CONFIGS = {
	--TODO: Come up with some.
}

return WorldConfigs