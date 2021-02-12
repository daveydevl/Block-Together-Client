
local fonts = {}

function makeText(parent, text, size)
	text = tostring(text)

	if fonts[size] == nil then
		fonts[size] = TTFont.new("font.ttf", size)
	end
	
	local wrapper = makeSprite(parent)
	
	local display = TextField.new(fonts[size], text)
	display:setTextColor(0xFFFFFF)
	
	wrapper:addChild(display)
	
	wrapper.setText = function(fl)
		fl = tostring(fl)
		
		local bool = false
		
		if fl:sub(1, 1) == "@" then
			if display.flame_symbol == nil then
				display.flame_symbol = makeImage(wrapper, "flame")
			end
			
			fl = fl:sub(2)
			bool = true
		elseif display.flame_symbol ~= nil then
		    display.flame_symbol:setAlpha(0)
		end
		
		display:setText(fl)
		
		if bool then
			display.flame_symbol:setPosition(display:getWidth() + 16, -display:getHeight() / 2 - 32)
		end
	end
	
	wrapper.setColor = function(color)
		display:setTextColor(color)
	end
	
	wrapper.setText(text)
	
	return wrapper
end

