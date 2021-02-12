


function makeSpinner(parent)
	local wrapper = makeSprite(parent)
	
	wrapper:onTouch(function() end)
	
	local bg = makeImage(wrapper, "spinner_bg")
	bg:setPosition(446, 906)
	bg:setAlpha(0.8)
	
	local spinner = makeImage(bg, "spinner")
	spinner:setAnchorPosition(64, 64)
	spinner:setPosition(94, 94)

	spinner:setAlpha(1.25)
	GTween.new(spinner, 1, {
		rotation = 360
	}, {
		ease = easing.linear,
		repeatCount = math.huge
	})
	
	wrapper.show = function(func)
		wrapper:setAlpha(1)
		wrapper.blockTouch = true
		
		func()
	end
	
	wrapper.hide = function(func)
		wrapper:setAlpha(0)
		wrapper.blockTouch = false
		
		func()
	end
	
	wrapper.hide(function() end)
	
	return wrapper
end