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
		speed = 3,
		acc = 0.25,
		deacceleration = 0.9,
		totalJumps = 3,
		jumpHeight = 1.5,
		jumpVelocityMult = 2,
		 
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
		speed = 1.5,
		acc = 0.5,
		deacceleration = 0.9,
		totalJumps = 1,
		jumpHeight = 1.5,
		jumpVelocityMult = 2,
		 
	},

	body = {
		w = 0.8,
		h = 1.1,
		mass = 1,
		friction = 0,
		shape = 'RECT'
	},
}