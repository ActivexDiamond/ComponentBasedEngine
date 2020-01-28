
------------------------------ IHealth ------------------------------
t = r.IHealth.instv
t.maxHealth = 100

------------------------------ Mob ------------------------------
t = r.Mob.instv

t.speed = 3
t.acceleration = 0.25
t.deacceleration = 0.9

t.totalJumps = 1
t.jumpHeight = 1.5
t.jumpVelocityMult = 2

------------------------------ MeleeWeapon ------------------------------
t = r.MeleeWeapon.instv

--TODO: Upgrade melee-weapon phases to allow altering of all stats not just hitbox.
t.maxDurability = 100
t.cooldown = 5

--TODO: Move hit-related stats to sub-table.
t.damage = 10
t.effects = {}
t.reHit = 0
t.hitbox = {
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
--	},
}
