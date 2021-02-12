


function makeEnemy()
	local wrapper = makeSprite(Game.stage_header)
	
	
	local chara = nil
	
	wrapper.setKyara = function(name)
		if chara ~= nil then
			chara:del()
			chara = nil
		end
		
		chara = makeCharacter(wrapper, name)
		
		chara:setAnchorPosition(300, 400)
		chara:setPosition(540, 512)
		chara:setScale(0)
	end
	
	wrapper.despawn = function()
		if chara ~= nil then
			chara:setScale(0)
		end
	end
	
	wrapper.death = function(func)
		GTween.new(chara, 2, {
			redMultiplier = 10,
			greenMultiplier = 10,
			blueMultiplier = 10,
			scaleX = 0,
			scaleY = 0
		}, {
			ease = easing.inOutExponential,
			onComplete = func
		})
	end
	
	wrapper.attack = function()
		GTween.new(chara, 0.5, {
			scaleX = 2,
			scaleY = 2,
			redMultiplier = 5,
			greenMultiplier = 5,
			blueMultiplier = 5,
			
		}, {
			ease = easing.inExponential,
			reflect = true,
			repeatCount = 2
		})
	end
	
	wrapper.spawn = function()
		GTween.new(chara, 1, {
			scaleX = 1,
			scaleY = 1
		}, {
			ease = easing.inOutExponential
		})
	end
	
	
	return wrapper
end