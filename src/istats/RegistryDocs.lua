--[=[
idVars:
	- Attached to id, read-only.
	- Classes/Interfaces requiring idVars must define their defaults in:
		 istats/defaults/idv.
	
classVars:		??? Needed ???
	- Attached to class, aka static, read-write.	

instanceVars:
	- Applied onto the instance, read-write, each instant holds its own version.
	- Classes/Interfaces requiring idVars must define their defaults in:
		 istats/defaults/instv.
	
Registry init:
	Iterate over the following folders, indexing into the following:
	defaults/idv/ 	-> Reg.defaults.idv
	defaults/instv/ -> Reg.defaults.instv
	data/ 			-> Reg.data
		Note: data is split into idv/instv based on the provided defaults.
			A datum with no underlying default is ignored! 
			TODO: Change it so that extra datums are considered instvs?
			
	Extra:
		defaults can be a function

Registry usage:
	1- Thing (or child) calls Registry:apply(self, id).					--initial call.
	2- The hierarchy of self is explored to gather all classes/interfaces,
		def a table of their __name__ fields as h.						--fetch hierarchy.
		  
	3- All entries defined by the given class's defaults get 			---idv
		getters created for them in the instance:						--create getters, with defaults-fallback.
		--(iterating over h)											--
		className = h[i]												--iterate all defaults of the given hierarchy.
		def = Reg.defaults.idv[className]								--fetch all default idvs of className (current iteration).
		dat = Reg.data													--access ALL registry data. (not sectioned into idv/instv)
		for k, v in ipairs(def) 										--iterating the defaults of a given class.
			fstr = "get" .. capitalize(k)								--Format getter name.
			instance[fstr] = function() return dat[id][k] or v end --set instance.getVar to return the data[id][var] or defaults.idv[className][var].
			--def[k] CAN be a func which computes the value based on instance and id. 
	4- Similar to the above, except the vars are:
		- Applied directly to instance, instead of being wrapped in getters:
			(iterating over h ; className)								
			className = h[i]											--iterate all defaults of the given hierarchy.
			def = Reg.defaults.instv[className]							--fetch all default instvs of className (current iteration).
			dat = Reg.data												--access ALL registry data. (not sectioned into idv/instv)
			for k, v in ipairs(def)										--iterating the defaults of a given class.					
				instance[k] = dat[id][k] or v 								--set instance[var] to data[id][var] or defaults.intsv[className][var]
	
	
TODO: Optimize operation of the registry.	
	
	
--]=]