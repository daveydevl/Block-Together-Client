

function makeHpBar(parent, bool)
	local c = "red"

	if bool then
		c = "blue"
	end

	local bar = makeImage(parent, c.."_bar")
	local bar_txt = makeText(bar, "0%", 64)
	
	if not bool then
		bar_txt:setY(120)
	end
	
	
	local bar_bg_wrapper = makeSprite(bar)
	local bar_bg = makeImage(bar_bg_wrapper, c.."_hp")
	local change = makeText(bar, "", 256)
	
	bar_bg_wrapper:setClip(12, 0, 938, 72)
	
	local tmp_set = 0
	local total = 0
	
	bar.init = function()
		bar_bg:setPosition(-938, 12)
		bar_txt.setText("0/"..total)
		tmp_set = 0
	end
	
	local setGet = {
		set = function(obj, name, value)
			if name == "current" then
				tmp_set = value
				value = math.ceil(value)
				local txt = value .. "/" .. total
				bar_txt.setText(txt)
				
			end
		end,
		
		get = function(obj, name)
			if name == "current" then
				return tmp_set
			end
		end
	}
	
	bar.setTotal = function(t)
		total = t
	end
	
	bar.setPercent = function(c, func)
		local per = c / total
		GTween.new(bar_bg, 1, {
			x = 12 - ((1 - per) * 950)
		}, {
			ease = easing.outExponential,
			onComplete = func
		})
		
		GTween.new(setGet, 1, {
			current = c
		}, {
			ease = easing.outExponential
		})
		
		local diff = c - tmp_set
		
		change.setColor(0xFF0000)
		
		if diff > 0 then
			change.setColor(0x00FF00)
		elseif diff == 0 then
			change.setColor(0xFFFFFF)
		end
		
		diff = math.ceil(math.abs(diff))
		change.setText(diff)
		
		if bool then 
			change:setPosition(472 - change:getWidth() / 2, -50)
		else
			change:setPosition(472 - change:getWidth() / 2, 250)
		end
		
		change:setAlpha(1)
		
		GTween.new(change, 0.5, {
			alpha = 0
		}, {
			ease = easing.linear
		})
	end
	
	bar.setPercentFirst = function()
		GTween.new(bar_bg, 1.9, {
			x = 12
		}, {
			ease = easing.linear,
			delay = 0.5
		})
		
		GTween.new(setGet, 1.9, {
			current = total
		}, {
			ease = easing.linear,
			delay = 0.5
		})
	end
	
	return bar
end
	
	