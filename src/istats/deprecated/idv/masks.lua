------------------------------ Categories (Endpoints) ------------------------------
local IBoundingBox = {}
do
	IBoundingBox.masks = {}
	local m = IBoundingBox.masks
	m.BLOCK,
	m.FREE,
	m.FREE,
	m.FREE,
	m.ITEM_DROP,
	m.FREE,
	m.FREE,
	m.FREE,
	m.HOSTILE_MOB,
	m.NEUTRAL_MOB,
	m.PASSIVE_MOB,
	m.PLAYER,
	m.NPC_PRJ,
	m.PLAYER_PRJ,
	m.FREE,
	m.MP		
	
		= 1, 2, 4, 8, 16, 32, 64, 128, 256, 516, 1024, 2048, 4096, 8192, 16384, 32768
	
------------------------------ Masks ------------------------------
	m.NPC = m.HOSTILE_MOB + m.NEUTRAL_MOB + m.PASSIVE_MOB
	m.MOB = m.NPC + m.PLAYER
		
	m.PRJ = m.NPC_PRJ + m.PLAYER_PRJ
	
	m.ENTITY = m.PRJ + m.MOB + m.ITEM_DROP
	
	m.SOLID = m.ENTITY + m.BLOCK
end


---======================== TODO: Fix the registry =============================
local m = IBoundingBox.masks
local t = {}
t.categories = {}
t.masks = {}
------------------------------ Categories ------------------------------
local c  = t.categories	--self:setCategory(c)

c.unassigned = m.MP

c.Block = m.BLOCK	
c.ItemDrop = m.ITEM_DROP
c.Player = m.PLAYER

--TODO: remove after cleaning up Registry.
c.Zombie = m.HOSTILE_MOB
------------------------------ Masks ------------------------------
local k = t.masks	--self:setMask(m.SOLID - k)

k.unassigned = 0

k.ItemDrop = m.PRJ + m.NPC
k.Player = m.PLAYER + m.PLAYER_PRJ
k.Npc = m.NPC + m.ITEM_DROP

--TODO: remove after cleaning up Registry.
k.Zombie = m.NPC + m.ITEM_DROP

--[[
Full hierarchy:
-Cats:

c.WorldObj = m.MP
	c.Block = m.BLOCK
	
	c.Entity = m.MP
		c.ItemDrop = m.ITEM_DROP
		c.Projectile = m.MP
			--No template classes for them; tagged upon construction from Projectile.
			c.PlayerPrj = m.PLAYER_PRJ
			c.NpcPrj = m.NPC_PRJ
		c.Mob = m.MP
			c.Player = m.PLAYER
			c.Npc = m.MP

-------------------------------------------------------------------------------------	

-Masks:
	
k.WorldObj = 0
	k.Block  = 0

	k.Entity = 0
		k.ItemDrop = m.PRJ + m.PLAYER
		k.Projectile = 0
		k.Mob = 0
			k.Player = m.PLAYER + m.PLAYER_PRJ
			k.Npc = m.NPC + m.ItemDrop
--]]

return t


--[[
Example:
0111	solid
0010	prj
0100	mob

0111	solid
0110	prj + mob

0001	solid - (prj + mob)

0111	solid
0010	mob
0100	player


--]]