--[[



------------------------------ Overview / tl;dr ------------------------------
Item: Any inventory item, including any metadata it requires (durability, etc...)

ItemStack: Holds an item; multiple, but only if stackable and with matching data/metadata.
	Holds a reference to it's parent slot (Or ItemDrop, if in-world).
	Used by slots to hold items.
	
Slot: Holds an ItemStack.
	Holds a reference to it's parent inventory, if any. 
	API offers/manages interaction with:
		- Other ItemStacks.	E.g. Stacking items, auto insertion, etc...
		- Other Slots.		E.g Mouse slot interaction (sorting?).
		- Filtering
	
	
IInventory: Holds multiple Slots, manages interaction between them.
	Holds a reference to it's parent, if any; Can be an IInventory or Thing (perhaps also other things).
	API offers/manages interaction with:
		- Direct interaction with slots: 
			-> Based on index. E.g. Mouse slot, specific-inserters.
			-> Based on contents (querying). E.g. A battery querying chargables.
				+ More querying filters/patterns.
		- Interaction with inventory as a whole. E.g. Hoppers, auto-filling an inventory, etc...
		- Global operations on all Slots. E.g (un)filter all, clear all, restock all, etc... 		

Note: The mouse slot is a single slot (? single-slot-inv ?) belonging to the player,
	Not treated specially. Not different. 

ItemDrop: Holds a single ItemStack, exists in the world. 
	Used to drop ItemStacks into the world.
	[debate] Auto-merges with nearby identical ItemDrops (minecraft-style).


ITickable: The same interface used by WorldObj's.
	Is attached to Item's.
	Whenever a new ItemStack is assigned to a Slot,
		It checks if that ItemStack's Item is tickable, if yes,
		It adds it to it's parent's list of tickables, and notifies it. (same for removal)
			If an inventories tickables list "becomes" non-empty, it subscribes to ticking,
			If an inventories tickables list "becomes" empty, it unsubscribes from ticking,
			(inventories are ticked by some global inv-ticker in the world / loaded-chunks)
		
		(? if a Slot's (?/ItemStack's?) parent is nil, it never gets ticked, or subs directly. ?)
	

TODO: Design Drawing/GUI interfaces. 




















--]]