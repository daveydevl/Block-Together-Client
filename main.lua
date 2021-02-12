application:setBackgroundColor(0)
stage:setClip(0, 0, 1080, 3840)

revmob = {
	showAd = function(obj) end
}

pcall(function()
	require "ads"
	revmob = Ads.new("revmob")
end)

Game = {}

Game.wrapper = makeSprite(stage)
Game.hud = makeSprite(stage)

Game.main = makeImage(Game.wrapper, "stage_bg")

Game.stage = makeSprite(Game.wrapper)
Game.stage:setY(1920)
Game.stage:setClip(0, 0, 1080, 1920)

Game.pages = makeSprite(Game.main)
Game.pages:setPosition(0, 460)

local pages = {"stages", "stats", "skins", "leaders"}

Game.currentPage = pages[1]

for index, page in ipairs(pages) do

	if page == "stages" or page == "stats" then
		Game[page] = makeSprite(Game.pages)
	else
		Game[page] = makeImage(Game.pages, page.."_bg")
	end
	
	Game[page]:setClip(0, 0, 1080, 1370)
	Game[page]:setPosition((index - 1) * 1080, 0)
	
	Game[page].button = makeText(Game.main, firstToUpper(page), 48)
	
	Game[page].button:setPosition(262 * index - 115 - Game[page].button:getWidth() / 2, 400)
	
	Game[page].button_bg = makeImage(Game.main, "button_bg")
	Game[page].button_bg:setColorTransform(0.8, 0.8, 0.8, 1)
	Game[page].button_bg:setPosition(262 * index - 230, 330)
	
	Game[page].button_bg:onTouch(function(x, y)
		if Game.currentPage == page then
			return
		end
		
		Game.currentPage = page
		enableTouch = false
		
		GTween.new(Game.active_bg, 0.5, {x = 262 * index - 230}, {
			ease = easing.inOutExponential,
			onComplete = function()
				enableTouch = true
			end
		})
		
		GTween.new(Game.pages, 0.5, {x = index * -1080 + 1080}, {
			ease = easing.inOutExponential
		})
	end)
end

Game.active_bg = makeImage(Game.main, "button_bg")
Game.active_bg:setColorTransform(0, 0.7, 0, 1)
Game.active_bg:setPosition(32, 330)

Game.nameIndicator = makeText(Game.main, "Loading...", 48)

Game.nameIndicator:onTouch(function()
	local textInputDialog = TextInputDialog.new("Change Name", "Type in your desired name", Game.username, "Cancel", "Change")

	local function onComplete(event)
		if event.buttonIndex == 1 then --change button
			api.changeName(event.text)
		end
	end

	textInputDialog:addEventListener(Event.COMPLETE, onComplete)
	textInputDialog:show()
end)


Game.flagIndicator = makeFlag(Game.main, "ZZ")
Game.flameIndicator = makeFlameIndicator(Game.main, 0)

Game.nameIndicator:setPosition(540 - (Game.nameIndicator:getWidth() + 96 + Game.flameIndicator:getWidth()) / 2, 80)
Game.flagIndicator:setPosition(Game.nameIndicator:getX() + Game.nameIndicator:getWidth() + 32, 32)
Game.flameIndicator:setPosition(Game.flagIndicator:getX() + 128, 80)

Game.levelIndicator = makeText(Game.main, "Level 0", 42)
Game.levelIndicator:setPosition(278 - Game.levelIndicator:getWidth() / 2, 160)

Game.levelBar = makeBar(Game.main, 0)
Game.levelBar:setPosition(32 + 16, 196)

Game.xpIndicator = makeText(Game.main, "0%", 42)
Game.xpIndicator:setPosition(278 - Game.xpIndicator:getWidth() / 2, 290)

Game.energyText = makeText(Game.main, "Energy", 42)
Game.energyText:setPosition(802 - Game.energyText:getWidth() / 2, 160)

Game.energyIndicator = makeText(Game.main, "0/0", 42)
Game.energyIndicator:setPosition(802 - Game.energyIndicator:getWidth() / 2, 290)

Game.energyBar = makeBar(Game.main, 0)
Game.energyBar:setPosition(556, 196)

Game.main:addChild(Game.xpIndicator)

Game.stages.map = makeImage(Game.stages, "map")

Game.stages.overlay = makeImage(Game.stages, "battle_bg")

Game.animate_level_once = true


local map = Game.stages.map

local coords = {
	{10, 59},
	{29, 53},
	{45, 49},
	{56, 63},
	{63, 51},
	{54, 41},
	{78, 42},
	{78, 24},
	{56, 23},
	{41, 34},
	{22, 27},
	{13, 43},
	{44, 9},
	{89, 13},
	{92, 35},
	{90, 58},
	{73, 74},
	{57, 83},
	{35, 85},
	{35, 69}
}

map:setPosition(10 * -80 + 460, 59 * -80 + 605)

Game.left_btn = makeImage(Game.stages, "left")
Game.right_btn = makeImage(Game.stages, "right")

GTween.new(Game.left_btn, 0.4, {
	x = 16
}, {
	ease = easing.inCircular,
	reflect = true,
	repeatCount = math.huge
})

GTween.new(Game.right_btn, 0.4, {
	x = 1080 - 156 - 16
}, {
	ease = easing.inCircular,
	reflect = true,
	repeatCount = math.huge
})

Game.left_btn:setAlpha(0)
Game.right_btn:setAlpha(0)
Game.left_btn:setPosition(48, 580)
Game.right_btn:setPosition(1080 - 48 - 156, 580)

function dimStageBody(callback)
	GTween.new(Game.stage_body, 0.5, {
		redMultiplier = 0.5,
		greenMultiplier = 0.5,
		blueMultiplier = 0.5
	}, {
		ease = easing.inOutExponential,
		onComplete = callback
	})
	
	GTween.new(Game.stage_body_blocks, 0.5, {
		redMultiplier = 0.5,
		greenMultiplier = 0.5,
		blueMultiplier = 0.5
	}, {
		ease = easing.inOutExponential
	})
end

function undimStageBody(callback)
	GTween.new(Game.stage_body, 0.5, {
		redMultiplier = 1,
		greenMultiplier = 1,
		blueMultiplier = 1
	}, {
		ease = easing.inOutExponential,
		onComplete = callback
	})
	
	GTween.new(Game.stage_body_blocks, 0.5, {
		redMultiplier = 1,
		greenMultiplier = 1,
		blueMultiplier = 1
	}, {
		ease = easing.inOutExponential
	})
end

Game.levelShown = 1
Game.max_stage = 1

Game.tents = {}

for i = 1, #coords do
	local t = makeImage(Game.stages.map, "tent")
	
	local coord = coords[i]
	t:setPosition(coord[1] * 16, coord[2] * 16)
	t:setAlpha(1)
	
	t.txt = makeText(Game.stages.map, "Stage "..i, 64)
	t.txt.setColor(0xe0ffff)
	t.txt:setPosition(coord[1] * 16 - 5, coord[2] * 16 - 8)
	t.txt:setScale(0.2)
	
	local t_func = function()
		if Game.levelShown ~= i or Game.pages:getX() ~= 0 or Game.wrapper:getY() ~= 0 or (Game.left_btn:getAlpha() == 0 and Game.right_btn:getAlpha() == 0) then
			return
		end
	
		t:setColorTransform(2, 2, 2, 1)
		GTween.new(t, 0.5, {
			redMultiplier = 1,
			greenMultiplier = 1,
			blueMultiplier = 1
		}, {
			ease = easing.linear
		})
		
		if i == Game.max_stage + 1 then
			cmd.alert("This stage is locked!")
		else
			makeConfirm("Stage "..i, "expends " .. values.energy_req(i) .. " energy", "Enter", function()
				Game.c_stage = i
			
				dimStageBody()
				Game.enemyHp:setPosition(68, -175)
				Game.playerHp:setPosition(68, 838 - 72 + 75 + 100)
				
				Game.kyara.despawn()
				Game.enemy.despawn()
				
				Game.enemyHp.setTotal(values.enemy_health(Game.c_stage))
				Game.playerHp.setTotal(values.player_health(Game.rank_health))
				
				Game.enemyHp.init()
				Game.playerHp.init()
				
				Game.stage_flame_indicator.reset()
				Game.stageState.reset()
				
				Game.history = {}
				
				for i2 = Game.stage_body_blocks:getNumChildren(), 1, -1 do
					Game.stage_body_blocks:getChildAt(i2):del()
				end
				
				cmd.changeScreen(2)
				
				api.beginStage(i)
			end)
		
		end
		
		
	end
	
	t:onTouch(t_func)
	t.txt:onTouch(t_func)
	
	table.insert(Game.tents, t)
end

local help = makeImage(Game.stages, "help")
help.img = makeImage(Game.hud, "tutorial")

help.img:setAlpha(0)
help.img:onTouch(function() end)


help.btn = makeButton(help.img, "circle_cancel", "Close", 0xf1a9a0, function()
	enableTouch = false
	
	GTween.new(help.img, 0.5, {
		alpha = 0
	}, {
		ease = easing.inOutExponential,
		onComplete = function()
			help.btn:setAlpha(0)
			help.img.blockTouch = false
			enableTouch = true
		end
	})
	
	GTween.new(Game.wrapper, 0.5, {
		redMultiplier = 1,
		greenMultiplier = 1,
		blueMultiplier = 1
	}, {
		ease = easing.inOutExponential
	})
end)
help.btn:setAlpha(0)

help.btn:setPosition(540 - 264, 1920 - 280)

help:setPosition(888, 35)
help:onTouch(function()
	enableTouch = false
	
	help.btn:setAlpha(1)

	help:setColorTransform(5, 5, 5, 1)
	GTween.new(help, 0.5, {
		redMultiplier = 1,
		greenMultiplier = 1,
		blueMultiplier = 1
	}, {
		ease = easing.linear
	})
	
	GTween.new(Game.wrapper, 0.5, {
		redMultiplier = 0.1,
		greenMultiplier = 0.1,
		blueMultiplier = 0.1
	}, {
		ease = easing.inOutExponential
	})
	
	GTween.new(help.img, 0.5, {
		alpha = 1
	}, {
		ease = easing.inOutExponential,
		onComplete = function()
			help.img.blockTouch = true
			enableTouch = true
		end
	})
	
end)

Game.stages.map.help = help

function animateLevel()
	Game.left_btn:setAlpha(0)
	Game.right_btn:setAlpha(0)

	local coord = coords[Game.levelShown]
	
	GTween.new(map, 0.5, {
		x = coord[1] * -80 + 460,
		y = coord[2] * -80 + 605
	}, {
		ease = easing.inOutExponential,
		onComplete = function()
			if Game.levelShown ~= 1 then
				Game.left_btn:setAlpha(1)
			end
			
			if Game.levelShown ~= Game.max_stage + 1 and Game.levelShown ~= #Game.tents then
				Game.right_btn:setAlpha(1)
			end
		end
	})
end

Game.left_btn:onTouch(function()
	Game.levelShown = Game.levelShown - 1
	
	animateLevel()
end)

Game.right_btn:onTouch(function()
	Game.levelShown = Game.levelShown + 1
	
	animateLevel()
end)
Game.stages.map:setScale(5)

local rank_index = 1
local ranks = {"attack", "health", "flame"}

for _, rank in pairs(ranks) do
	local intro = "rank_" .. rank
	
	Game.stats[intro] = makeImage(Game.stats, "upgrade_bg")
	Game.stats[intro]:setY(462 * rank_index - 446)
	
	
	
	rank_index = rank_index + 1

	Game.stats[intro].items = {}

	for y = 1, 2 do
		for x = 1, 5 do
			local num = (y - 1) * 5 + x
			local cc = makeImage(Game.stats[intro], "r_"..rank)
			
			cc:setPosition(191.25 * x - 108.75, 176 * y - 124)
			cc:setAlpha(0)
			cc:onTouch(function()
				if Game[intro] + 1 == num then
					makeConfirm("increase "..rank.." rank", "locked", "@" .. values["rank_"..rank.."_unlock"](num), function()
						api["unlockRank"..firstToUpper(rank)]()
					end)
					
					cc:setColorTransform(5, 5, 5, 1)
				
					GTween.new(cc, 0.5, {
						redMultiplier = 1,
						greenMultiplier = 1,
						blueMultiplier = 1
					}, {
						ease = easing.inOutExponential
					})
				end
			end)
			
			Game.stats[intro].items[num] = cc
		end
	end
	
	local txt = makeText(Game.stats[intro], "", 48)
	txt:setPosition(540, 400)
	
	Game.stats[intro].txt = txt
end

Game.skins.items = {}
Game.skins.active = makeImage(Game.skins, "active_chara")

for y = 1, 3 do
	for x = 1, 6 do
		local num = (y - 1) * 6 + x
		local c = makeCharacter(Game.skins, "p_" .. num)
		c:setPosition(163 * x - 93, 428 * y - 372)
		c:onTouch(function()
		
			if Game.chara_bools[num] == 0 then
				makeConfirm("unlock character", "locked", "@" .. values.chara_unlock(Game.chara_amts + 1), function()
					api.unlockChara(num)
				end)
				
				c:setColorTransform(5, 5, 5, 1)
			
				GTween.new(c, 0.5, {
					redMultiplier = 0.2,
					greenMultiplier = 0.2,
					blueMultiplier = 0.2
				}, {
					ease = easing.inOutExponential
				})
			elseif Game.c_chara ~= num then
				api.changeChara(num)
				
				c:setColorTransform(5, 5, 5, 1)
			
				GTween.new(c, 0.5, {
					redMultiplier = 1,
					greenMultiplier = 1,
					blueMultiplier = 1
				}, {
					ease = easing.inOutExponential
				})
			end
		end)
		
		if num == 1 then
			Game.skins.active:setPosition(c:getPosition())
		end
		
		Game.skins.items[num] = c
	end
end

Game.skins:addChild(Game.skins.active) --move to top

--stage stuff

Game.stage_body = makeImage(Game.stage, "stage_body")

Game.stage_body_blocks = makeSprite(Game.stage)

Game.stage_header = makeImage(Game.stage, "bg")

Game.stage_flame_indicator = makeFlameIndicator(Game.stage_header, 0)
Game.stage_flame_indicator:setPosition(1080 - Game.stage_flame_indicator:getWidth() - 64, 160)

Game.stage_body:setPosition(0, 838)
Game.stage_header:setPosition(0, -4)

Game.stage_body_blocks:setPosition(50, 838 + 50)
Game.stage_body_blocks:setClip(0, -28, 1080, 1082)

Game.stage_header:setClip(0, 0, 1080, 838)

Game.enemy = makeEnemy()

Game.rank = 1
Game.kyara = makeKyara()
Game.kyara:setPosition(252 + 128 + 96 + 64, 550 + 200) 

Game.enemyHp = makeHpBar(Game.stage_header, false)
Game.playerHp = makeHpBar(Game.stage_header, true)

Game.enemyHp:setPosition(68, -175)
Game.playerHp:setPosition(68, 838 - 72 + 75 + 100)

Game.stageState = makeStageState()

Game.spinner = makeSpinner(Game.hud)

api._init()

