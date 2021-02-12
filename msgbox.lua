

function makeMsgBox(txt1, txt2, callback)
	local ignore = makeSprite(Game.hud)
	
	local dialog = makeSprite(Game.hud)
	dialog:setY(-500)
	
	local vp = Viewport.new()
	vp:setClip(0, 0, 1080, 300)
	vp:setContent(Game.main)
	
	dialog:addChild(vp)
	
	local dialog_end = makeImage(dialog, "stage_bg_end")
	dialog_end:setY(300)
	
	local text1 = makeText(dialog, txt1, 42)
	local text2 = makeText(dialog, txt2, 48)
	local notif = makeText(dialog, "^ Click Here ^", 64)
	
	notif:setPosition(540 - notif:getWidth() / 2, 420)
	
	text1.setColor(0x00FF00)
	text2.setColor(0x00FF00)
	
	Game.hud:addChild(dialog)
	
	local dismissDown = function()
		enableTouch = false
		
	    dialog:setColorTransform(3, 3, 3, 1)
		
		GTween.new(notif, 0.5, {
			alpha = 0
		}, {
			ease = easing.linear
		})
		
		GTween.new(dialog, 0.5, {
			redMultiplier = 1,
			greenMultiplier = 1,
			blueMultiplier = 1
		}, {
			ease = easing.linear,
			onComplete = function()
				callback()
				
				GTween.new(dialog, 0.5, {
					y = 2287
				}, {
					ease = easing.inOutExponential,
					delay = 2.5,
					onInit = function()
						cmd.changeScreen(1)
					end,
					
					onComplete = function()
						ignore:del()
						dialog:del()
					end
				})
			end
		})
	end
	
	dialog:onTouch(function()
		dismissDown()
	end)
	
	notif:onTouch(function()
		dismissDown()
	end)
	
	ignore:onTouch(function() end) --add handler
	
	local tx = Game.xpIndicator:getX() + Game.xpIndicator:getWidth() + 32
	local ty = Game.xpIndicator:getY()
	
	text1:setPosition(tx, ty)
	
	local dx = Game.flameIndicator:getX() + Game.flameIndicator:getWidth() + 32
	local dy = Game.flameIndicator:getY()
	
	text2:setPosition(dx, dy)
	
	GTween.new(dialog, 0.5, {y = 838}, {
		ease = easing.inOutExponential,
		onComplete = function()
			enableTouch = true
		end
	})
end


