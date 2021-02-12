

function makeKyara()
	local wrapper = makeSprite(Game.stage_header)
	wrapper:setAnchorPosition(64, 200)
	
	local chara = nil
	
	local prepare = makeImage(wrapper, "prepare")
	local strike = makeImage(wrapper, "strike")
	local fallback = makeImage(wrapper, "fallback")
	local heal = makeImage(wrapper, "heal")
	
	wrapper.setKyara = function(name)
		if chara ~= nil then
			chara:del()
			chara = nil
		end
		
		chara = makeCharacter(wrapper, name)
		chara:setY(400)
		chara:setColorTransform(5, 5, 5, 1)
		
		wrapper:addChild(heal) --so it's above chara
	end
	
	prepare:setAnchorPosition(84, 0)
	strike:setAnchorPosition(64, 0)
	fallback:setAnchorPosition(64, 0)
	heal:setAnchorPosition(0, 500)
	
	prepare:setAlpha(0)
	strike:setAlpha(0)
	fallback:setAlpha(0)
	heal:setAlpha(0)
	
	heal:setY(-210 + 500)
	
	wrapper.despawn = function()
		if chara ~= nil then
			chara:setY(400)
		end
	end
	
	wrapper.spawn = function()
		chara:setColorTransform(10, 10, 10, 1)
		
		GTween.new(chara, 3, {
			y = 0,
			redMultiplier = 1,
			greenMultiplier = 1,
			blueMultiplier = 1
		}, {
			ease = easing.outExponential
		})
	end
	
	wrapper.heal = function(amt, func)
		heal:setAlpha(1)
		heal:setColorTransform(3, 3, 3, 1)
		heal:setScaleY(0.5)
		wrapper:setScale(2)
	
		GTween.new(heal, 1, {
			alpha = 0,
			scaleY = 2.5,
			redMultiplier = 1,
			greenMultiplier = 1,
			blueMultiplier = 1
		}, {
			ease = easing.inExponential
		})
		
		GTween.new(chara, 1.5, {
			redMultiplier = 1,
			greenMultiplier = 1,
			blueMultiplier = 1
		}, {
			ease = easing.inOutExponential
		})
		
		GTween.new(wrapper, 1.5, {
			scaleX = 1,
			scaleY = 1
		}, {
			ease = easing.outExponential
		})
		
		
		local hp = Game.player_health + amt
		if hp > Game.player_max_health then
			hp = Game.player_max_health
		end
		Game.player_health = hp
		
		Game.playerHp.setPercent(Game.player_health, func)
	end
			
	
	wrapper.attack = function(amt, func)
		
		prepare:setPosition(64, 64)
		fallback:setPosition(64, -256)
		strike:setPosition(64, -256)		
		
		GTween.new(chara, 0.2, {
			y = 75,
			redMultiplier = 5,
			greenMultiplier = 5,
			blueMultiplier = 5
		}, {
			ease = easing.outExponential,
			onComplete = function()
				local hp = Game.enemy_health - amt
				if hp < 0 then
					hp = 0
				end
				
			
				chara:setAlpha(0)
				
				prepare:setAlpha(1)
				
				GTween.new(Game.stage_header, 0.2, {
					redMultiplier = 0.2,
					greenMultiplier = 0.2,
					blueMultiplier = 0.2
				}, {
					ease = easing.linear
				})
				
				GTween.new(Game.enemy, 0.2, {
					redMultiplier = 4,
					greenMultiplier = 4,
					blueMultiplier = 4
				}, {
					ease = easing.linear
				})
				
				GTween.new(strike, 0.2, {
					redMultiplier = 4,
					greenMultiplier = 4,
					blueMultiplier = 4
				}, {
					ease = easing.linear
				})
				
				GTween.new(prepare, 0.2, {
					redMultiplier = 4,
					greenMultiplier = 4,
					blueMultiplier = 4
				}, {
					ease = easing.linear
				})
				
				wait(0.1, function()
					prepare:setAlpha(0)
					strike:setAlpha(1)
					
					
					
					GTween.new(strike, 0.3, {
						y = -320
					}, {
						ease = easing.outExponential
					})
					
					
					wait(0.12, function()
						strike:setAlpha(0)
						
						local x, y = Game.enemy:getPosition()
						local frames = 40
						local counter = 0
						
						Game.shake = function()
							Game.enemy:setPosition(x + math.random(-frames, frames), y + math.random(-frames, frames))
							
							frames = frames - 2
							
							counter = counter + 1
							if counter > 10 then
								Game.enemy:setPosition(x, y)
								Game.enemy:removeEventListener(Event.ENTER_FRAME, Game.shake)
							end
						end
						
						Game.enemy:addEventListener(Event.ENTER_FRAME, Game.shake)
						
						Game.stage_header:setColorTransform(1, 1, 1, 1)
						Game.enemy:setColorTransform(6, 6, 6, 1)
						
						Game.enemy_health = hp
						Game.enemyHp.setPercent(Game.enemy_health, func)
						
						wait(0.2, function()
							GTween.new(Game.enemy, 0.5, {
								redMultiplier = 1,
								greenMultiplier = 1,
								blueMultiplier = 1
							}, {
								ease = easing.inOutExponential
							})
							
							strike:setAlpha(0)
							fallback:setAlpha(1)
							GTween.new(fallback, 0.2, {
								y = 64
							}, {
								ease = easing.outExponential
							})
							
							
							wait(0.2, function()
								fallback:setAlpha(0)
								chara:setAlpha(1)
								
								GTween.new(chara, 0.5, {
									y = 0
								}, {
									ease = easing.outBounce
								})
								
								GTween.new(chara, 0.5, {
									redMultiplier = 1,
									greenMultiplier = 1,
									blueMultiplier = 1
								}, {
									ease = easing.outExponential
								})
							end)
							
						end)
						
						
						
						
					end)
					
					
				end)
				
			
			
			end
		})
		
	end
	
	
	
	wrapper.poison = function(amt, func)
		local hp = Game.player_health - amt
		if hp < 0 then
			hp = 0
		end
		Game.player_health = hp
		
		wait(0.5, function()
		
			Game.playerHp.setPercent(Game.player_health, function() end)
		end)
	
		GTween.new(chara, 0.5, {
			rotation = 25,
			x = 100,
			y = 150,
			redMultiplier = 1.5,
			greenMultiplier = 0.5,
			blueMultiplier = 0.5
		}, {
			ease = easing.outExponential,
			onComplete = function()
				GTween.new(chara, 0.5, {
					rotation = 0,
					x = 0,
					y = 0,
					redMultiplier = 1,
					greenMultiplier = 1,
					blueMultiplier = 1
				}, {
					ease = easing.inOutExponential
				})
				func()
			end,
			delay = 0.4
		})
	
	end
	
	wrapper.death = function(func)
		GTween.new(chara, 2, {
			y = 300,
			redMultiplier = 0.1,
			greenMultiplier = 0.1,
			blueMultiplier = 0.1
		}, {
			delay = 1,
			ease = easing.inOutExponential,
			onComplete = func
		})
	end
	
	
	
	
	
	return wrapper
end