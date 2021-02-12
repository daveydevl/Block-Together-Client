

function makeBar(parent, percent)
	local bar = makeImage(parent, "bar")
	local bar_bg_wrapper = makeSprite(bar)
	local bar_bg = makeImage(bar_bg_wrapper, "bar_bg")
	
	bar_bg_wrapper:setClip(6, 0, 458 - 6, 36)
	bar_bg:setPosition(-452, 6)
	
	bar.setPercent = function(per)
		GTween.new(bar_bg, 2, {
			x = 6 - ((1 - per) * 458)
		}, {
			ease = easing.inOutExponential
		})
	end
	
	bar.setPercent(percent)
	
	return bar
end
	
	