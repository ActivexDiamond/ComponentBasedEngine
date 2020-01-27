local Mixins = require "libs.Mixins"
local Registry = require "istats.Registry"

local IHealth = {}

---Heal/Hurt
function IHealth:heal(n)
	assert(n >= 0, "Cannot heal negatively.")
	self.health = math.min(self.health + n, self.maxHealth)
end
function IHealth:hurt(n)
	assert(n >= 0, "Cannot deal negative damage.")
	if self.health == 0 then return end
	self.health = math.max(self.health - n, 0)
	if self.health == 0 then self:_onDeath() end
end

---Restore/Kill
function IHealth:restore() self.health = self.maxHealth end
function IHealth:kill() self.health = 0; self:_onDeath() end

---Callback
function IHealth:_onDeath() end

---Setup

Mixins.onPostInit(IHealth, function(self)
	self.maxHealth = self:getBaseMaxHealth()
	---If health was set by the instance, just bound it. 
	self.health = self.health and self:setHealth(self.health) or self.maxHealth
end)

function IHealth:setupHealth() 
	self.maxHealth = self:getBaseMaxHealth()
	self.health = self.health and self:setHealth(self.health) or self.maxHealth
end

---Health Getters/Setters
function IHealth:getHealth() return self.health end
--function IHealth:rawSetHealth(n) health = n end
function IHealth:setHealth(n) 
	self.health = math.max( math.min(n, self.maxHealth), 0 )
	if self.health <= 0 then self:onDeath() end
end

---MaxHealth Getters/Setters
function IHealth:getMaxHealth() return self.maxHealth end
--function IHealth:rawSetMaxHealth(n) maxHealth = n end
function IHealth:setMaxHealth(n) 
	self.maxHealth = n; self.health = math.min(self.health, self.maxHealth)
end

---BaseMaxHealth Getter
function IHealth:getBaseMaxHealth() return Registry:getMaxHealth(self.id) end

return IHealth


