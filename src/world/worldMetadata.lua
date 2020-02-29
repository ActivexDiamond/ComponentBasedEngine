local class = require "libs.cruxclass"

------------------------------ Helper Methods ------------------------------

------------------------------ Constructor ------------------------------
local WorldMetadata = class("WorldMetadata")
function WorldMetadata:init()
	--TODO: read-only classes. Their vars can be accessed directly since they're all final.
	--TODO: fetch defaults from the game's global defaults.
	self.dateCreated = os.date(WorldMetadata.DATE_FORMAT)
	self.dateLastPlayed = self.dateCreated
	self.totalTimePlayed = 0
	self.timesQuit = 0
end

------------------------------ Constants ------------------------------
WorldMetadata.DATE_FORMAT = "%Y-%m-%d %H:%M:%S"

return WorldMetadata