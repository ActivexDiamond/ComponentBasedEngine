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
		w = 0.5,
		h = 0.5,
		mass = 1,
		friction = 0,
	},
}

--[[
b2Vec2 vel = body->GetLinearVelocity();
float desiredVel = 0;
switch ( moveState )
{
  case MS_LEFT:  desiredVel = -5; break;
  case MS_STOP:  desiredVel =  0; break;
  case MS_RIGHT: desiredVel =  5; break;
}
float velChange = desiredVel - vel.x;
float impulse = body->GetMass() * velChange; //disregard time factor
body->ApplyLinearImpulse( b2Vec2(impulse,0), body->GetWorldCenter() );
--]]