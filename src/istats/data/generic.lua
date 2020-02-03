------------------------------ Blocks ------------------------------
data{"logOak", 
	name = "Oak Log",
	desc = "Log(0)",
	sprInv = "spinv_tree_log.png",
}

data{"stickWood", 
	name = "Wooden Stick",
	desc = "*pokes it with a stick*",
	sprInv = "spinv_tree_stick.png",
}

data{"coalOredrop", 
	name = "Coal Ore Drop",
	desc = "Lump(s) of coal.",
	sprInv = "spinv_coal_oredrop.png",
}

data{"ironIngot", 
	name = "Iron Ingot",
	desc = "The most common form of the most common metal.",
	sprInv = "spinv_iron_ingot.png",
}

data{"ironPlate", 
	name = "Iron Plate",
	desc = "Less common than an ingot, also less geometrical.",
	sprInv = "spinv_iron_plate.png",
}

data{"ironStick", 
	name = "Iron Stick",
	desc = "\"The\" better stick.",
	sprInv = "spinv_iron_stick.png",
}

------------------------------ Mobs ------------------------------
data{"mobZombie",
	name = "Undead",
	desc = "Zombie",
	
	speed = 1.5,
	totalJumps = 1,
	maxHealth = 50,
	
	w = 0.8,
	h = 1.1,
	mass = 1,
	friction = 0,
	category = masks.HOSTILE_MOB,
	mask = masks.NPC + masks.ITEM_DROP,
}	-- 0011 1000 0000 0001

data{"player",
	speed = 3,
	totalJumps = 3,

	w = 0.6,
	h = 1,
	mass = 1,
	friction = 0,
	
	category = masks.PLAYER,
	mask = masks.PLAYER + masks.PLAYER_PRJ,
}

------------------------------ Weapons ------------------------------
data{"swordStone",
	maxDurability = 50,
	cooldown = 2,
	damage = 5,
}

data{"swordIron",
	maxDurability = 250,
	cooldown = 2,
	damage = 15,
}

data{"spearStone",
	maxDurability = 50,
	cooldown = 2,
	damage = 5,
	hitbox = {
		{
		anchor = WeaponDef.NATURAL,
--					transition = WeaponDef.INSTANT,	--- skipped for last phase
			dur = 15,
			area = {0, 0, 0.1, 2},
		},
	},
}



















