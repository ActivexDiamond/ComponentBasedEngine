local WeaponDef = require "template.WeaponDef"

local t = {}

------------------------------ IWalk, IJump ------------------------------
t.movement = {
	speed = 3,
	acc = 0.25,
	deacceleration = 0.9,
}
t.jumping = {
	totalJumps = 1,
	jumpHeight = 1.5,
	jumpVelocityMult = 2,
}

------------------------------ MeleeWeapon ------------------------------
t.meleeWeapon = {
	--TODO: Upgrade melee-weapon phases to allow altering of all stats not just hitbox.
	maxDurability = 100,
	cooldown = 5,

	--TODO: Move hit-related stats to sub-table.
	damage = 10,
	effects = {},
	reHit = 0,
	hitbox = {
		start = {0, 0, 0, 0.2},
		startAnchor = WeaponDef.anchors.NATURAL,
		{
			anchor = WeaponDef.anchors.NATURAL,
			transition = WeaponDef.transitions.LINEAR_GROW,
			dur = 0.1,
			area = {0, 0, 1.5, 0.2},
		}, {
			anchor = WeaponDef.anchors.NATURAL,
			transition = WeaponDef.transitions.LINEAR_GROW,
--			transition = WeaponDef.transitions.INSTANT,	
			dur = 0.5,
			area = {0, 0, 0, 0.2},
		}, 
--		{
--			anchor = WeaponDef.anchors.NATURAL,
--			transition = WeaponDef.transitions.LINEAR_GROW,
--			dur = 2,
----			freq = 0.5,							--freq defaults to -1 (every tick)
--			area = {0, 0, 0, 0.8},
--		},
	},
}

return t