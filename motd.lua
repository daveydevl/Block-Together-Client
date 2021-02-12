
function makeMotd(text)
	if Game.motd ~= nil then
		Game.motd:del()
		Game.motd = nil
	end
	
	if Game.motd2 ~= nil then
		Game.motd2:del()
		Game.motd2 = nil
	end
	
	local txt = os.date("%A, %B %d, %Y")..": "..text

	Game.motd = makeText(Game.main, txt, 42)
	Game.motd2 = makeText(Game.main, txt, 42)
	
	Game.motd:setPosition(540, 1885)
	Game.motd2:setPosition(Game.motd:getWidth() + 796, 1885)
	
	Game.motd:setAlpha(0)
	GTween.new(Game.motd, 2, {
		alpha = 1
	}, {
		ease = easing.inOutExponential
	})
	
	Game.motd:addEventListener(Event.ENTER_FRAME, function()
		local x = Game.motd:getX() - 3
		if x < -Game.motd:getWidth() then
			x = Game.motd:getWidth() + 512
		end
		
		Game.motd:setX(x)
	end)
	
	Game.motd2:addEventListener(Event.ENTER_FRAME, function()
		local x = Game.motd2:getX() - 3
		if x < -Game.motd2:getWidth() then
			x = Game.motd:getWidth() + 512
		end
		
		Game.motd2:setX(x)
	end)
end