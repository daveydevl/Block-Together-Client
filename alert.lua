

function makeConfirm(title, subtxt, button, callback)
	local ignore = makeSprite(Game.hud)
	ignore.blockTouch = true
	
	local dialog = makeImage(Game.hud, "dialog")
	local title = makeText(dialog, title, 80)
	local subtext = makeText(dialog, subtxt, 60)
	
	ignore:onTouch(function() end) --add handler so anything under the dimmed bg cannot be clicked
	dialog:onTouch(function() end) --add handler so clicking on the dialog doesn't cause it to go away
	
	local dismissDown = function()
		enableTouch = false
		
		GTween.new(dialog, 0.5, {y = 2287}, {
			ease = easing.inOutExponential,
			onComplete = function()
				ignore:del()
				dialog:del()
				
				enableTouch = true
			end
		})
		
		GTween.new(Game.main, 0.5, {
			redMultiplier = 1,
			greenMultiplier = 1,
			blueMultiplier = 1
		}, {
			ease = easing.inOutExponential
		})
	
	end
	
	local cancel, play
	
	local dismissUp = function()
		enableTouch = false
		
		GTween.new(dialog, 0.5, {y = -335}, {
			ease = easing.inOutExponential,
			onComplete = function()
				ignore:del()
				dialog:del()
				
				cancel:del()
				play:del()
				
				enableTouch = true
			end
		})
		
		GTween.new(Game.main, 0.5, {
			redMultiplier = 1,
			greenMultiplier = 1,
			blueMultiplier = 1
		}, {
			ease = easing.inOutExponential
		})
	
	end
	
	cancel = makeButton(dialog, "circle_cancel", "Cancel", 0xf1a9a0, function()
		dismissDown()
	end)
	
	play = makeButton(dialog, "circle_play", button, 0xe0ffff, function()
		dismissUp()
		callback()
	end)
	
	title:setPosition(508 - title:getWidth() / 2, -16)
	subtext:setPosition(508 - subtext:getWidth() / 2, 550)
	
	cancel:setPosition(508 - 528 / 2, 95)
	play:setPosition(508 - 528 / 2, 95 + 158)
	
	dialog:setAnchorPosition(508, 264)
	dialog:setPosition(540, 2287)
	
	GTween.new(dialog, 0.5, {y = 960}, {
		ease = easing.inOutExponential,
		onComplete = function()
			enableTouch = true
		end
	})
	
	GTween.new(Game.main, 0.5, {
		redMultiplier = 0.3,
		greenMultiplier = 0.3,
		blueMultiplier = 0.3
	}, {
		ease = easing.inOutExponential
	})
end


