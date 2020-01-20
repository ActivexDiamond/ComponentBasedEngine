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
	stats = {
		movement = {
			speed = 3,
		},
		jumping = {
			totalJumps = 3,
		},
	},

	body = {
		w = 0.6,
		h = 1,
		mass = 1,
		friction = 0,
	},
}

data{"zombie",
	stats = {
		movement = {
			speed = 1.5,
		},
		jumping = {
			totalJumps = 1,
		},
	},
	body = {
		w = 0.8,
		h = 1.1,
		mass = 1,
		friction = 0,
		shape = 'RECT'
	},
}

data{"swordStone",
	stats = {
		meleeWeapon = {
			maxDurability = 50,
			cooldown = 2,
			damage = 5,
		},
	},
}

data{"swordIron",
	stats = {
		meleeWeapon = {		
			maxDurability = 250,
			cooldown = 2,
			damage = 15,
		},
	},
}

data{"spearStone",
	stats = {
		meleeWeapon = {	
			maxDurability = 50,
			cooldown = 2,
			damage = 5,
			hitbox = {
				{
					anchor = WeaponDef.CENTER_ALIGNED,
--					transition = WeaponDef.INSTANT,	--- skipped for last phase
					dur = 15,
					area = {0, 0, 0.1, 2},
				},
			},
		},
	},
}

