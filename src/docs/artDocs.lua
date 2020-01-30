--[[
@Jo
PS: Don't be offended. This is very from the ground up and basically assumes you
know nothing about the subject.
I am well aware you do know most of this stuff, but I want to be VERY sure that
you know them "correctly". Slight inaccuracies in definitions might slip through
daily conversations, but since we're doing proper gamedev together,
it's very crucial to be accurately-on the same page.
------------------------------ Terminology ------------------------------
---Art-related (useful to you directly):
Sprite: A static image used for an object. 
	(each frame of an animation is also called a sprite)
Animation: Animations will be composed out of multiple (seperate) frames, 
	Each frame would be composed of a single sprite (static image).
	The 'framerate' of it would not be saved in the art in anyway,
	Piskel has a preview (top-right) where you can adjust the speed to see how it looks,
	Just "tell" me the intended framerate once you're done.

Skeletal animation: A form similar to the animation above, but augmented with code/logic,
	E.g. You'd draw each limb of a character separately (different sprite),
	And I'd use code/physics to animate movement. (see further reading)
	
Skeletal art (not the proper term - I forget it): Useful for things such as equipment.
	E.g. The player, iron helmet, gold helmet, and multiple swords would each
	be seperate sprites. I'd 'overlay' them with code/logic. (see further reading)

Resolution: This always refers to the size that you set the canvas to,
	NOT the exact/precise dimensions of what you draw in it!!!
	E.g A 32x32 canvas filled with a block of stone has a resolution of 32x32,
	A 32x32 canvas with a tiny stick drawn in the middle ALSO has a resolution 32x32.
	Note: "empty space around what you draw" is defined by 100% transparent pixels,
		What I'm trying to say is, please don't mistake white for transparent;
		A white pixel is very different from a transparent one.

Transparency: How see-through something is, also known as alpha.
Opacity: How NOT-see-through something is.

RGBA [Color systems]: Red, Green, Blue, Alpha.
	In the modern world (most commonly) each pixel is stored as 4 bytes
	(1 byte = 8 bits. 4 bytes = 4*8 = 32 bits.)
	(Each byte can represent any integer in the range [0-255], inclusive)
	(This results in 16,777,216 (~16M) different possible colors, 
		if we count alpha, you'd get 4,294,967,296 (~4G))
		
	Those are also often referred to as "the red channel", "alpha channel", etc...
	
RGBA representation: A nibble is 4 bits (half a byte),
	A single hex digit ranges in [0-15], 4 bits have the same range.
	Hence, it's common to represent colors as 3 (4 with alpha) hex digits,
	Commonly prefixed with a hashtag. #AARRGGBB or #RRGGBB 
		E.g. #0000FF -> Solid blue.
		
Other color systems:
	HSB: Hue, Saturation, Brightness (Aka HSV, for value)
	CMY: Cyan, Magenta, Yellow.
	There are more...
		Internally, they work the same as RGB.
		They all also have alpha.
		They're mainly useful for artists, nothing technical.
		E.g in HSB you can move the B slider to make a color brighter,
		In RGB you'd have to move all 3 sliders an equal amount.
		
Collision mask (Aka mask): Used by anything in the world that is also solid,
	Basically defines what the definition of two objects touching is.
	If the masks of two objects overlap, they are colliding.
	
	Ideally, masks would always use precise-mapping,
	Aka every pixel (with non-zero alpha) in the sprite is collidable,
	Everything else is not.
	However this can be computationally-expensive for complex shapes,
	So often a simpler mask is used instead.
	E.g a complex shaped player humanoid would have a rectangular mask.
		(The smallest rectangle which still encompasses the whole player)
		(This could technically still have a lot of empty space (transparent pixels)
		which are being treated as collidable; sometimes it is made smaller so
		parts of the sprite might end up being not collidable)
	Either way, this is an imperfect best-we-can-do solution, but it's not nearly as
	bad as it sounds, you'll be shocked how common it actually is, and how much
	different sprites/masks are in most games you've played.

	For our case, just assume that the engine will always use precise masks,
	And draw accordingly.
	
	Reminder: Don't forget resolution = canvas size and is different from mask.
	A tiny torch in the middle of a 32x32 canvas has a small mask but a 32x32 resolution. 
	
	

---Non-art, but very general (still very useful to you):
"in the world": Things that exist in the game-world, aka map. 
	Basically anything not in an inventory.

Drawing: Drawing anything to the screen.
Rendering: Rendering stuff to the screen.
	Technically the above are similar, but rendering is for more 
	computationally heavy-stuff, the explanation behind this is a topic for another day.
		I personally use rendering to refer to in-the-world stuff,
		And drawing for HUD's/GUI's/Menus (inventories, etc...)
		
Item: Things that only exist inside inventories 
	(aka only show up in GUI's, not in the world)
	E.g sticks, ingots, etc... (examples given in the context of my usual game design)
Block: (see below for further details) Everything, in the world,
	That is placed and locked to the tile grid.
	
Item/Block: While items themselves only exist in inventories, many of them do have
	block "equivalents", and vice-versa.
		E.g. mining "a block of stone" would give "a stone block item",
		And  Placing "a stone block item" would create "a block of stone."
		
	What this means, on the technical side:
		Item/Block pairs still use completely different sprites for each;
			Their sprites are in no special way related - AT ALL.
			You don't even need to have them be the same size or anything.
			
	On the art'sy side: You should probably make sure they LOOK related,
		Aka make the player go "Oh, that dropped from this block."
		And/or "Oh, that's the same block, but inside my pocket.".



---Slightly more field-specific/technical, but still useful for you, 
				since you're my gf, and I use those daily:
Entity: (see below for further details) Everything, in the world,
	That is free-form (NOt locked to the grid - can move around freely)
	E.g Arrow, player, zombie.
	
Mob: A sub-category of entities; any living creature.
	E.g Player, zombie.
	
NPC: A sub-category of mobs; non-player-character (every mob except the player(s)) 
	E.g Zombie.
	
Hostile/Neutral/Passive/Ambient mobs: Sub-categories of mobs, 
	categorized by their behavior towards the player.
		Hostile: Attack on sight.			E.g. Zombies
		Neutral: Attack only if provoked	E.g. Wolves
			(by attacking them, getting too close, what have you)
		Passive: Never attack.				E.g. Sheep
		Ambient: Useless.					E.g. Some bird which doesn't even drop
			(mostly decorative)						Any items when killed.
			
Menus vs GUIs: I know you know both terms, 
	but in the context of games they are slightly altered:
	Menus: Game-menus, E.g. the main menu, world-select menu, options menu, etc...
	GUI: The interfaces that pop-up when you interact with something in the world,
		E.g. The player's inventory, some machine's GUI, etc...
		E.g. "The chest's GUI" 
		(in-game GUI's for in-game stuff are rarely/never referred to as menus.)
	UI: Synonym for GUI. 0% different in 2020, was very different in the 20th century.
	
HUD: Heads-Up Display, is drawn on the screen, you don't interact with it.
	E.g. your health-bar or number of coins you have, always shown in some corner.
		

------------------------------ Further Reading ------------------------------
Large-blocks:
Multiblocks:
Connected textures:
Random textures:
Perlin noise:
Procedurally generated textures
Procedurally generated art:
------------------------------ Long Version ------------------------------

--- Technical requirements:

There are 3 main "types" of "objects" you will be making sprites for
	



------------------------------ Short Version ------------------------------












--]]