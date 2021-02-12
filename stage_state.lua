

function makeStageState()

	local wrapper = makeImage(Game.stage_header, "win")
	
	wrapper.win = function()
		wrapper.setImage("win")
		
		GTween.new(wrapper, 0.5, {
			scaleY = 1,
			alpha = 1
		}, {
			ease = easing.inOutExponential,
			onComplete = wrapper.animate
		})
	end
	
	wrapper.lose = function()
		wrapper.setImage("lose")
		
		GTween.new(wrapper, 0.5, {
			scaleY = 1,
			alpha = 1
		}, {
			ease = easing.inOutExponential,
			onComplete = wrapper.animate
		})
	end
	
	wrapper.reset = function()
		wrapper:setAlpha(0)
		wrapper:setScaleY(0)
		wrapper:setColorTransform(1, 1, 1, 1)
		
		if wrapper.tween ~= nil then
			wrapper.tween:setPaused(true)
			wrapper.tween = nil
		end
	end
	
	wrapper.animate = function()
		wrapper.tween = GTween.new(wrapper, 0.8, {
			redMultiplier = 5,
			greenMultiplier = 5,
			blueMultiplier = 5
		}, {
			delay = 0.5,
			ease = easing.inExponential,
			repeatCount = 2,
			reflect = true
		})
	end
	
	wrapper:setAnchorPosition(0, 135)
	wrapper:setPosition(0, 400)
	
	wrapper.reset()
	
	return wrapper
end