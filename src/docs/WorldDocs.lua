--[[


------------------------------ Init ------------------------------
configs {
	name
	w/h
	spawnPoint
	difficulty
	gameRules
	worldGenConfigs
	etc...
}

metadata {
	dateCreated
	dateLastPlayed
	totalTimePlayed
	timesQuit 
	(Should the world save it's own stats locally? ??? even blocks broken, etc..)
	etc...
}

------------------------------ Save / Load ------------------------------

------------------------------ Add / Remove ------------------------------
addObj(obj, x, y)		--World automatically handles snapping.
removeObj(obj)
removeObj(x, y, w, h)

------------------------------ Getters / Queries ------------------------------
getObj(obj)				--Uses the bounding box of 'obj'.
getObj(x, y, w, h)		

getAllObjs(id, obj)			--Same as below but uses the bounding box of 'obj'.						
getAllObjs(id, x, y, w, h)	--Gets all objs with id='id' in x/y/w/h.
							If no box is provided, checks the whole world.
							TODO: version to check only loaded chunks.

getAllObjs(filter)			--Gets all objs matching the filter, a table.
	Allows the following:
		strict = bool; An obj must match ALL the entries. Default: false.
		ids = {}; A table of ids.
		class = class; Looks for a specific class.
		instanceof = Uses the instanceof metamethod.
		tags, etc... ('material=iron', that sort of stuff.)

Note: In general, w/h default to a single pixel.

------------------------------ Player / Mouse ------------------------------
onMouseClick(x, y)
	getObj(x, y, 1, 1)
	If obj is IClickable, fire it's onClick callback.
	If obj is IBreakable, and LMB, fire it's onMine callback.
	
	Fire the player's click method, passing it the obj.
	If LMB, fire the player's mine method, passing it the obj. 

	??? Fire global click/mine events, with the obj (and the player?) ???
--]]