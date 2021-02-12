
commands = {
	
	error = function(func, msg)
		enableTouch = false
		
		local dialog = AlertDialog.new("Error", msg, "Dismiss")
		
		dialog:addEventListener(Event.COMPLETE, function()
			func()
		end)
		
		dialog:show()
	end,
	
	showAd = function(func)
		revmob:showAd()
		func()
	end,
	
	setApiKey = function(func, key)
		api_key = key
		
		local file = io.open("|D|api_key.txt", "w")
		file:write(key)
		file:close()
		
		func()
	end,
	
	updateLeaders = function(func, leaders)
		for i = Game.leaders:getNumChildren(), 1, -1 do
			Game.leaders:getChildAt(i):del()
		end
	
		for i = 1, #leaders do
			local leader = makeLeader(i, leaders[i][1], leaders[i][2], leaders[i][3])
			leader:setPosition(64, 140 * i - 80)
		end
		
		Game.leaders.overlay = makeImage(Game.leaders, "battle_bg")
		
		func()
	
	end,
	
	setMOTD = function(func, motd)
		makeMotd(motd)
		
		func()
	end,
	
	updateInfo = function(func, username, country, xp, energy, max_stage, flame, rank_attack, rank_health, rank_flame, c_chara, chara_num)
		Game.username = username
		Game.max_stage = max_stage
		Game.chara_num = chara_num
		
		Game.rank_attack = rank_attack
		Game.rank_health = rank_health
		Game.rank_flame = rank_flame
		
		Game.c_chara = c_chara
		
		for i = 1, max_stage do
			Game.tents[i]:setAlpha(1)
		end
		
		Game.chara_bools = toBits(chara_num)
		
		for i = 1, 18 do
			Game.skins.items[i].setCharacter("p_"..i)
			Game.skins.items[i]:setColorTransform(0.2, 0.2, 0.2, 1)
		end
		
		Game.chara_amts = 0
		for i = 1, #Game.chara_bools do
			if Game.chara_bools[i] == 1 then
				Game.chara_amts = Game.chara_amts + 1
				Game.skins.items[i]:setColorTransform(1, 1, 1, 1)
			end
		end
		
		
		
		Game.skins.active:setPosition(Game.skins.items[c_chara]:getPosition())
		
		if max_stage ~= #Game.tents then
			Game.tents[max_stage + 1]:setAlpha(0.5)
		end
		
		if Game.animate_level_once then
			Game.levelShown = max_stage
			Game.animate_level_once = false
		end
		
		animateLevel()
		
		Game.nameIndicator.setText(username)
		Game.nameIndicator:setX(540 - (Game.nameIndicator:getWidth() + 96 + Game.flameIndicator:getWidth()) / 2)
		
		Game.flagIndicator.setFlag(country)
		Game.flagIndicator:setX(Game.nameIndicator:getX() + Game.nameIndicator:getWidth() + 32)
		
		Game.flameIndicator.setValue(flame)
		Game.flameIndicator:setX(Game.flagIndicator:getX() + 128)
	
		local level, percent = values.level(xp)

		Game.levelIndicator.setText("Level "..level)
		Game.levelIndicator:setX(278 - Game.levelIndicator:getWidth() / 2)
		
		Game.xpIndicator.setText(math.floor(percent * 100).."%")
		Game.xpIndicator:setX(278 - Game.xpIndicator:getWidth() / 2)
		
		Game.levelBar.setPercent(percent)
		
		Game.energy = energy
		Game.maxEnergy = values.max_energy(level)
		
		if Game.energyTimer ~= nil then
			Game.energyTimer:stop()
			Game.energyTimer = nil
		end
		
		if Game.energy < Game.maxEnergy then
			Game.energyTimer = Timer.new(1000)
			
			Game.energyCounter = 10
			
			Game.energyTimer:addEventListener(Event.TIMER, function()
				if Game.energyCounter == -1 then
					Game.energy = Game.energy + 1
					
					Game.energyCounter = 10
					Game.energyBar.setPercent(Game.energy / Game.maxEnergy)
					
					if Game.energy == Game.maxEnergy then
						Game.energyIndicator.setText(Game.energy.."/"..Game.maxEnergy)
						Game.energyIndicator:setX(802 - Game.energyIndicator:getWidth() / 2)
						Game.energyTimer:stop()
						return
					end
				end
				
				local pad = "0"
				if Game.energyCounter == 10 then
					pad = ""
				end
				
				Game.energyIndicator.setText(Game.energy.."/"..Game.maxEnergy.." - 0:" .. pad .. Game.energyCounter)
				Game.energyIndicator:setX(802 - Game.energyIndicator:getWidth() / 2)
				
				Game.energyCounter = Game.energyCounter - 1
			end)
			Game.energyTimer:start()
		else
			Game.energyIndicator.setText(Game.energy.."/"..Game.maxEnergy)
			Game.energyIndicator:setX(802 - Game.energyIndicator:getWidth() / 2)
		end
		
		Game.energyBar.setPercent(Game.energy / Game.maxEnergy)
		
		local ranks = {"attack", "health", "flame"}
		
		for _, rank in pairs(ranks) do
			local intro = "rank_" .. rank
			local c_rank = Game[intro]
		
			for i = 1, 10 do
				Game.stats[intro].items[i]:setAlpha(0)
			end
			
			if c_rank < 10 then
				Game.stats[intro].items[c_rank + 1]:setAlpha(0.2)
			end
		
			for i = 1, c_rank do
				Game.stats[intro].items[i]:setAlpha(1)
			end
			
			local txt = Game.stats[intro].txt
			local text = ""
			
			if rank == "attack" then
				text = values.block_attack(1, c_rank) .. " damage/block"
			elseif rank == "health" then
				text = values.player_health(c_rank) .. " health"
			elseif rank == "flame" then
				text = c_rank .. "x flame"
			end
			
			txt.setText(text)
			txt:setX(540 - txt:getWidth() / 2)
			
		end
		
		func()
	
	end,
	
	showSpinner = function(func)
		Game.spinner.show(func)
	end,
	
	hideSpinner = function(func)
		Game.spinner.hide(func)
	end,
	
	changeScreen = function(func, num)
		enableTouch = false
	    --1 - main, 2 - stage
		
		local cy = 0
		
		if num == 1 then
			cy = 0
		elseif num == 2 then
			cy = -1920
		end
		
		GTween.new(Game.wrapper, 1, {y = cy}, {
			ease = easing.inOutExponential,
			onComplete = function()
				enableTouch = true
				func()
			end
		})
	end,
	
	
	beginStage = function(func, seed)
		Game.history = {}
		
		setRandomSeed(seed)
		
		enableTouch = false
		
		for i = 1, 6 do
			for i2 = 1, 6 do
				local b = makeBlock(i, i2)
				b:setY((i2 - 7) * 166 - 32)
			end
		end
		
		realignBlocksFirst()
		
		wait(2.5, function()
		    undimStageBody(function() enableTouch = true end)
		end)
		
		Game.enemyHp:setY(-175)
		Game.playerHp:setY(941)
		
		GTween.new(Game.enemyHp, 1, {
			y = 16
		}, {
			ease = easing.inOutExponential
		})
		
		GTween.new(Game.playerHp, 1, {
			y = 838 - 72 - 16
		}, {
			ease = easing.inOutExponential
		})
		
		wait(0.1, function()
			Game.enemyHp.setPercentFirst()
			Game.playerHp.setPercentFirst()
		end)
		
		
		Game.kyara.setKyara("p_" .. Game.c_chara)
		Game.kyara.spawn()
		
		Game.enemy.setKyara("e_" .. Game.c_stage)
		
		
		Game.enemy_max_health = values.enemy_health(Game.c_stage)
		Game.enemy_health = Game.enemy_max_health
		
		Game.player_max_health = values.player_health(Game.rank_health)
		Game.player_health = Game.player_max_health
		
		wait(0.2, function()
			Game.enemy.spawn()
		end)
		
		func()
	end,
	
	alertUnlock = function(func, msg)
		makeUnlock(msg, func)
	end,
	
	alert = function(func, msg)
		makeDialog(msg, func)
	end,
	
	showMessage = function(func, txt1, txt2)
		makeMsgBox(txt1, txt2, func)
	end
}




