--[[
---------------------------- Reference for below ----------------------------
Materials:
	Metal, Stone, Wood, Plastic:
        Metal: Iron, Copper, Steal, Gold, Titanium, etc...
        Stone: Andesite, Granite, Diorite, Lime, etc..
        Wood: Oak, Spruce, Birch, Acacia, etc...
        Plastic: Polyethelene, Polystyrene, etc...
----------------------------------------------------------------------------

Bases:
	Form: Ingot, Plate, Stick, Cable
	
    Machine: Furnace, Pulverizer, Grinder, Compactor
    Utility: Chest, Crate, WorkTable
    Automation: Inserter, Transporter, ConveryorBelt,
    
    Tool: Pickaxe, Shovel, Drill, Wrench
    Weapon: Sword, Bow, Shield
    
    World: Block, Slab, Stair, Door, Glass
    Misc: Dye, Resource
        
    ------------ More Bases --------------
    Mob: Zombie, Skeleton, Player, Villager
    Upgrades: Speed, Efficiency, etc...
    
    
Tags:
	BasePrefix:
		Mob: 
			Type: Zombie, Skeleton, Player, Villager
			
		Upgrades:
			Type: Speed, Efficiency, etc...
			[Target]: Any Category, Subcategory, or Entry
			([x] -> 'x' is optional)		
    Creative
    Portable
    Color: Red, Blue, White, Black
    Size: Tiny, Small, [Medium], large, Huge, ; Quarter, Half, Double, Quad
    FuelSource: SolidFuel, LiquidFuel, GaseousFuel, Electrical, Steam, Thermal.
    Material: [see above]
    Resistance: BlastResistant, WaterProof, FireProof, 
    Lighting: Transparent
    
    
    
Ranges/Ordering:
	Tags: 0+ subs, 0-1 each.
	BasePrefix: 0+ subs, 0-1 each.
	BaseCore: 1
	Base -> 1
	
Ordering (elaborated):
	Tags:
		Creative
		Portable 
		Color
		Size
		FuelSource
		Material
	Base:
		[Prefix]			; (sub-sub's defined by the sub itself)
		Core
	Separation: '|' between categories, '_' between prefixes.
					No caps (case insensitive) or spaces allowed.
	
	Summary: tag|othertag|moretags|prefix_core
	
	Full :	creative|portable|color|size|fuelsource|material|prefix_core
	Range:     0-1  |  0-1  | 0-1 | 0-1 |    0-1    |  0-1  |  0+*  _  1
		
	Note*:	Prefixes can be divided into subcategories.
			All prefix-sub's are (each) mutually-exclusive.
			Each prefix can define each of it's subs as optional or required.







------------------- DEPRECATED ------------------------------
Proposed conventions:
	Sort by frequency.
	Sort by English rules.

	material_base_tags	[1, 1, 0+]
	
	base_material_tags	[1, 1, 0+]
	base_material_tags	[1, 0+, 0+]
	TODO: Divide tags.

Examples: 
    Iron Ingot
    Iron Plate
    Iron Dust
    
    Copper Ingot
    Gold Ingot
    
    Stone Chest
    Stone Large Chest
    
    Andesite Block
    Iron Block
    Glass Block
    
    Copper Cable
    
    Stone SolidFuel Furnace
    Iron SolidFuel Furnace
    Iron LiquidFuel Furnace
    Stone SolidFuel Pulverizer
    Iron Electric Pulverizer        
    
    Red Dye
    Blue Dye
    Creative Large Battery
    Creative Large Portable Battery

    Large Copper Liquid Tank
    Tiny Iron Gas tank
        
Proposals [initial]:
    Large Stone Chest
    SolidFuel Iron Furnace
    LiquidFuel Iron Furnace
    SolidFuel Stone Pulverizer
    Electric Iron Pulverizer

--]]