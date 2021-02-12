

local blocks = {}

for x = 1, 6 do
	blocks[x] = {}
end

local types = {"attack", "health", "poison", "flame"}

function isEQ(x, y, type)
	return x > 0 and y > 0 and x <= 6 and y <= 6 and blocks[x][y].type == type
end

function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

local similar = {}

local required = {}

for i = 1, 6 do
	required[i] = 0
end

local delay = 0

local block_commands = {
	attack = function(amt, func)
		local val = values.block_attack(amt, Game.rank_attack)
		Game.kyara.attack(val, func)
	end,
	
	health = function(amt, func)
		local val = values.block_heal(amt, Game.rank_health)
		Game.kyara.heal(val, func)
	end,
	
	poison = function(amt, func)
		local val = values.block_poison(amt, Game.c_stage)
		Game.enemy.attack()
		Game.kyara.poison(val, func)
	end,
	
	flame = function(amt, func)
		local val = values.block_flame(amt, Game.rank_flame)
		Game.stage_flame_indicator.increase(val, func)
	end
}

local state_check = function()
	if Game.player_health <= 0 then
		Game.kyara.death(function()
			Game.stageState.lose()
			api.finishStage(Game.history)
		end)
		return true
	end
	
	if Game.enemy_health <= 0 then
		Game.enemy.death(function()
			Game.stageState.win()
			api.finishStage(Game.history)
		end)
		return true
	end
	
	return false
end

function makeBlock(x, y)
	local rnd = getRandom()
	
	local psn_amt = Game.c_stage * 0.7
	
	if rnd < 25 then
		t = 1
	elseif rnd < 50 then
		t = 2
	elseif rnd < 75 + psn_amt then
		t = 3
	elseif rnd < 100 then
		t = 4
	end
	
    local type = types[t]
	local block = makeImage(Game.stage_body_blocks, "block_" .. type)
	
	block.x = x
	block.y = y
	
	block.cx = block.x * 166 - 166
	block.cy = block.y * 166 - 166
	block.type = type
	
	block:setX(block.cx)
	
	blocks[block.x][block.y] = block
	
	block.moveDown = function()
		
		if block.y - 1 > 0 then
			blocks[block.x][block.y - 1].moveDown()
		else
			required[block.x] = required[block.x] + 1
		end
		
		block.cy = block.cy + 166
	end
	
	block.realignFirst = function()
		block.y = block.cy / 166 + 1
		blocks[block.x][block.y] = block
		
		GTween.new(block, 1, {y = block.cy}, {
			delay = (8 - block.y) / 5 + (math.random() / 5),
			ease = easing.inOutExponential
		})
	end
	
	block.realign = function()
		block.y = block.cy / 166 + 1
		blocks[block.x][block.y] = block
		
		
		GTween.new(block, 0.5, {y = block.cy}, {
			ease = easing.inOutExponential
		})
	end
	
	block.findSimilar = function()
		
		for cx = -1, 1 do
			for cy = -1, 1 do
				if math.abs(cx + cy) == 1 then
					local dx = block.x + cx
					local dy = block.y + cy
					
					if isEQ(dx, dy, type) then
						local test = blocks[dx][dy]
						
						if not table.contains(similar, test) then
							table.insert(similar, test)
							test.findSimilar()
						end
					end
				end
			end
		end
	end
	
	block:onTouch(function()
		enableTouch = false
	
		similar = {block}
		
		table.insert(Game.history, (block.y - 1) * 6 + block.x)
		
		once_only = true
		
		block.findSimilar()
		
		for i = 1, 6 do
			required[i] = 0
		end
		
		for i = 1, #similar do
			
			similar[i]:moveDown()
			
			local out = makeImage(Game.stage, "block_" .. block.type)
			out:setPosition(similar[i]:getX() + 50, similar[i]:getY() + 838 + 50)
			out:setColorTransform(2.5, 2.5, 2.5, 1)
			
			local c = similar[i].type
			
			if i == #similar then
				GTween.new(out, 0.5, {alpha = 0, redMultiplier = 1, greenMultiplier = 1, blueMultiplier = 1}, {
					ease = easing.linear,
					onInit = function()
						wait(0.1, function()
							realignBlocks()
						end)
					end,
					onComplete = function()
						out:del()
					end
				})
			else
				GTween.new(out, 0.5, {alpha = 0}, {
					ease = easing.linear,
					onComplete = function()
						out:del()
					end
				})
			end
			
			similar[i]:removeFromParent()
		end
		
		for i = 1, 6 do
			for i2 = 1, required[i] do
				local b = makeBlock(i, i2)
				b:setY((i2 - required[i] - 1) * 166 - 166)
			end
		end
		
		if #similar > 2 then
			dimStageBody()
			
			block_commands[block.type](#similar, function()
				if state_check() then
					return
				end
				
				if block.type ~= "poison" and block.type ~= "health" then
				
					Game.enemy.attack()
					Game.kyara.poison(values.enemy_damage(Game.c_stage), function() 
						if not state_check() then
							undimStageBody(function()
							    enableTouch = true
							end)
						end
					end)
				else
					undimStageBody(function()
						enableTouch = true
					end)
				end
			end)
		else
			wait(0.4, function()
				enableTouch = true
			end)
		end
	end)
	
	return block			
end

function realignBlocks()
	local parent = Game.stage_body_blocks
		
	for i = 1, parent:getNumChildren() do
		parent:getChildAt(i).realign()
	end
end

function realignBlocksFirst()
	local parent = Game.stage_body_blocks
	
	for i = 1, parent:getNumChildren() do
		parent:getChildAt(i).realignFirst()
	end
end


