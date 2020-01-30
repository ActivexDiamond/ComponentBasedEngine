--[[

All the following tests were performed by executing each
method twice; once after setMeter(32), 
	and once after setMeter(1).
The entire test was reloaded everytime the meterscale was changed. 

[b = body ; s = shape ; f = fixture ; p = love.physics]

layout:
method(params) ; args	->	res_32	;	res_1

========================================
p.setMeter(ms)
p.getMeter()	->	64	;	1

========================================
p.newWorld(-3, 9.8)
world:getGravity()	->	-3, 9.8000001907349	;	SAME
	Note: Changed ms to 3200 and ran. Method returned same
	results; but the simulation ran much slower/broken-like.
========================================
world:setGravity(-3, 9.8)	-> Ran the same test as above.
	But calling setGravity after world creation. Same results as above.
========================================

shape sizes
body position
a mix of both

mass, density
friction, restitution

s:getPoints ; b:getWorldPoints()

b:getLinearVelocity ; b:setLinearVelocity
b:applyForce ; b:applyImpulse

p:newWorld(xgravity, ygravity)

========================================
Conclusions:
setMeter(ms) -> Used to allow you to use pixel coordinates in all of your game;
For positions (bodies, etc...), sizes (shapes, etc...),
And even forces (setGravity, applyForce, setLinearVelocity, etc...).

Plan:
Since, in TechCove, I intend to use meters for everything.
I shall, 
1- setMeter(1)
2- define the MS to use; use it only in:
	1- At the start of love.draw: love.graphics.scale(MS, MS)
	
	
	
	
	DEPRECATED
	2- Object creation code (pos/dims)
	3- Moving objects by setting their coords directly 
		(Which would most likely never occur)
		























--]]