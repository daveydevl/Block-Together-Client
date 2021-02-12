


function makeFlameIndicator(parent, num)

	local wrapper = makeSprite(parent)
	
	local flameIndicator = makeText(wrapper, "@" .. formatComma(num), 48)
	local current = num
	
	local tmp_set = num
	local prv = 0
	
	local setGet = {
		set = function(obj, name, value)
			if name == "flame" then
				tmp_set = value
				
				local tt = math.floor(value)
				
				if prv == tt then
					return
				end
				
				prv = math.floor(value)
				
				flameIndicator.setText("@"..formatComma(prv))
				
			end
		end,
		
		get = function(obj, name)
			if name == "flame" then
				return tmp_set
			end
		end
	}
	
	wrapper.setValue = function(fl)
		current = fl
		
		GTween.new(setGet, 1, {
			flame = current
		}, {
			ease = easing.outSquare
		})
	end
	
	wrapper.increase = function(fl, func)
		current = current + fl
		
		GTween.new(setGet, 1, {
			flame = current
		}, {
			ease = easing.outSquare,
			onComplete = func
		})
	end
	
	wrapper.reset = function()
		current = 0
		tmp_set = 0
		prv = 0
		
		flameIndicator.setText("@0")
	end
	
	return wrapper
end