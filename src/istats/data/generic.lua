data{"logOak", 
	name = "Oak Log",
	desc = "Log(0)"
}

data{"plankOak", 
	name = "Oak Plank",
	desc = "Depressed Logs."
}

data{"stickWood", 
	name = "Wooden Stick",
	desc = "*pokes it with a stick*"
}

data{"mobZombie",
	name = "Undead",
	desc = "Zombie",
	maxHealth = 50
}

data{"player",
	speed = 3,
	totalJumps = 3,

	w = 0.6,
	h = 1,
	mass = 1,
	friction = 0,
}

data{"zombie",
	speed = 1.5,
	totalJumps = 1,

	w = 0.8,
	h = 1.1,
	mass = 1,
	friction = 0,
	shape = 'RECT'
}



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



















