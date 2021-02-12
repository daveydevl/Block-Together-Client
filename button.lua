
function makeButton(parent, image, text, color, callback)
	local button = makeImage(parent, image)
	
	local text = makeText(button, text, 64)
	text.setColor(color)
	
	text:setPosition(button:getWidth() / 2 - text:getWidth() / 2, 95)
	
	button.setText = function(txt)
		text.setText(txt)
		text:setPosition(button:getWidth() / 2 - text:getWidth() / 2, 95)
	end
		
	
	button:onTouch(function()
		button:setColorTransform(2, 2, 2, 1)
		text:setColorTransform(5, 5, 5, 1)
	
		GTween.new(button, 0.2, {
			redMultiplier = 1,
			greenMultiplier = 1,
			blueMultiplier = 1
		}, {ease = easing.linear})
		
		GTween.new(text, 0.2, {
			redMultiplier = 1,
			greenMultiplier = 1,
			blueMultiplier = 1
		}, {ease = easing.linear})
		
		callback()
	end)
	
	return button
end



	