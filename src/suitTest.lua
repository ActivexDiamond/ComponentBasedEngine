local suit = require "libs.suit"

function love.load()
	coal = love.graphics.newImage("assets/spr/inv/spinv_coal_oredrop.png")
	ingot = love.graphics.newImage("assets/spr/inv/spinv_iron_ingot.png")
	plate  = love.graphics.newImage("assets/spr/inv/spinv_iron_plate.png")
	stick = love.graphics.newImage("assets/spr/inv/spinv_iron_stick.png")
	
	items = {coal, ingot, plate, stick}
	selected = 1
	sprCell = 48
end


function love.update(dt)
	suit.layout:reset(0, 0)
	print(suit.layout:row(1, 1))
	print(suit.layout:row(1, 1))
	print(suit.layout:row(1, 1))
	
	
	suit.layout:reset(0, 0); --suit.layout:row(sprCell, sprCell) --suit.layout:left(sprCell, sprCell)
	local slot = suit.ImageButton(items[selected + 0], suit.layout:col(sprCell, sprCell ))
	local slot = suit.ImageButton(items[selected + 1], suit.layout:col(sprCell, sprCell )) 
	local slot = suit.ImageButton(items[selected + 2], suit.layout:col(sprCell, sprCell ))
	local slot = suit.ImageButton(items[selected + 3], suit.layout:col(sprCell, sprCell ))
	
--	if slot.hit then
--		print('slot', slot.hit)
--		selected = selected + 1
--		selected = selected > #items and 1 or selected
--	end
--	
--	local button = suit.Button("Hello, World!", suit.layout:row()) 
--	if button.hit then
--		print('button', button.hit)
--        show_message = not show_message
--        hit = button.hit
--    end
--    
--    if show_message then
--        suit.Label("How are you today? ->" .. hit, suit.layout:row())
--    end
end


--local show_message = false
--function love.update(dt)
--	suit.layout:reset(200, 200)
--	-- Put a button on the screen. If hit, show a message.
--    if suit.Button("Hello, World!", suit.layout:row(100, 100)).hit then
--        show_message = not show_message
--    end
--
--    -- if the button was pressed at least one time, but a label below
--    if show_message then
--        suit.Label("How are you today?", suit.layout:row())
--    end
--    
----   spr = love.graphics.newImage("assets/spr/spinv/spinv_coal_oredrop.png")
--   spr = love.graphics.newImage("assets/spr/spinv/spinv_coal_oredrop.png")
--   suit.ImageButton(spr,suit.layout:row())
--end

function love.draw()
    suit.draw()
end




