--[=[

TODO: Optimize operation of the registry.

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
	defaults/ 		-> Reg.defaults
	data/ 			-> Reg.data
		Note: data is split into idv/instv based on the provided defaults.
			A datum with no underlying default is ignored! 
			TODO: Change it so that extra datums are considered instvs?
			
	Extra:
		defaults can be a function

Registry usage:
	1- Thing (or child) calls Registry:apply(self, id).					--initial call.
	2- The hierarchy of inst is explored to gather all classes/interfaces,
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
	
	
================ OUTDATED ================ ALSO TERMINOLOGY CHANGED GREATLY ================ 
In-place functions:
	t.__f is used for default-fallbacks: is called with f(id, instance, t, k, v)
		- If present for t.__f[k], is indented into getVar() as the default-fallback.
		- Else, the native-default is indented directly.
		 
	t.__d is used for data-computation: is called with f(instance, id, t, k, v, datum)
		- If present for t.__d[k], is called with the native-default and datum,
				It's return value is applied into the instance.
		- Else, the datum is applied directly, else, the native-default is applied.
	
	General:
		1- Take priority over a native-default.					
		2- Are passed the var (k) and native-default (v), if any.
		3- [__d only] Are passed the value from the datapack (datum), if any.
	
		Terminology:
			r.t = Registry.defaults.i__v.className
			
			instance = the instance being instantiated
			t = r.t									--aka the class's defaults.i__x
			k = var 								--aka what is indexed with in r.t[k]
			v = r.t[k]  							--aka the value of var.
			native-default   = r.t[k] 				--aka v
			default-fallback = r.t.__f[k] 			
			default-compute  = r.t.__f[k]
			datum			 = r.data.t[k]			--aka the datapack value of var.
	
Templates:
	Used for: 
		1- Data-driven object creation / during runtime.
			template = class
		2- Data-driven template creation (combining) during runtime.
			template = {class, interface0, interface1, ...}

	Registry:create(id, args)
		1- Uses the id to fetch a template.
		2- Fetches the [base] class from template.
			If any mixins are present, includes them into the class, in order.
		3- return combinedClass(args) 		--calling the constructor of the [base] class.
		4- 
			TODO: Figure out how to pass args/initial-values to the given mixins, if any.	

--]=]

