local class = require "libs.cruxclass"
local Thing = require "template.Thing"

local Registry = require "istats.Registry"

------------------------------ Constructor ------------------------------
local MeleeWeapon = class("MeleeWeapon", Thing)
function MeleeWeapon:init(id)
	Thing.init(self, id)
	Registry:applyStat(id, self, "meleeWeapon")
	
--	print('weapon', #self.hitbox)
end

------------------------------ Constants ------------------------------

return MeleeWeapon

--[[
	Example:
hitbox {
	{
		dur = 10
		anchor = origin / center / center-aligned
		area = {x, y, w, h}
transition = instant / linear-grow
	}
	
	{
	
	}
}



Definite lists:
	Combat -> Melee-Weapons, Ranged-Weapons, Stomping, Projectiles   
	
	Inventory -> Template Classes, Basic Inventory Interfaces,
	
	Crafting
	
	Rendering -> Basic Drawing Interfaces
	
	GUI
	
	World
	
	Entities -> Basic Movement Interfaces
	

Potential Lists:
	Player
	
	Entities / Mobs / Movement / Physics
	
	Saving / Serialization


Item
Slot, ItemStack
(Item/Block bridges)
Inventory (?)
IStorage

IWalk, IJump, IFly




--]]