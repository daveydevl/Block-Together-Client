




function makeDialog(text, func)
	local wrapper = makeImage(Game.hud, "box")
	local text = makeText(wrapper, text, 64)
	
	enableTouch = false
	
	wrapper:setAnchorPosition(0, 175)
	
	wrapper:setPosition(0, 1000)
	wrapper:setScaleY(0)
	wrapper:setAlpha(0)
	
	text:setPosition(540 - text:getWidth() / 2, 192)
	
	GTween.new(Game.wrapper, 1, {
		redMultiplier = 0.2,
		greenMultiplier = 0.2,
		blueMultiplier = 0.2
	}, {
		ease = easing.inOutExponential
	})
	
	GTween.new(wrapper, 1, {
		scaleY = 1,
		alpha = 1
	}, {
		ease = easing.inOutExponential
	})
	
	wait(1.5, function()
		GTween.new(wrapper, 1, {
			scaleY = 0,
			alpha = 0
		}, {
			ease = easing.inOutExponential,
			onComplete = function()
				wrapper:del()
				enableTouch = true
				func()
			end
		})
		
		GTween.new(Game.wrapper, 1, {
			redMultiplier = 1,
			greenMultiplier = 1,
			blueMultiplier = 1
		}, {
			ease = easing.inOutExponential
		})
	end)

	return wrapper
end