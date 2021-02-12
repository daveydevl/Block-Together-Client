

values = {
	
	chara_unlock = function(chara)
		return 50 * chara - 2
	end,
	
	rank_attack_unlock = function(rank)
		return 23 * rank - 25
	end,
    
    rank_health_unlock = function(rank)
        return 34 * rank - 38
    end,
    
    rank_flame_unlock = function(rank)
        return 45 * rank - 50
    end,
	
	player_health = function(rank)
		return 109 * rank - 34
	end,
	
	enemy_health = function(c_stage)
		return 15 * c_stage
	end,
	
	enemy_damage = function(c_stage)
		return 3 * c_stage + 4
	end,
	
	level = function(xp)
		return math.modf(math.sqrt(xp))
	end,
	
	energy_req = function(c_stage)
        return 2 * c_stage - 1
    end,
	
	max_energy = function(level)
		return 2 * level - 1
	end,
	
	block_attack = function(amt, rank)
        return rank * amt
    end,
    
    block_heal = function(amt, rank)
        return rank * amt * 2
    end,
    
    block_flame = function(amt, rank)
        return amt
    end,
    
    block_poison = function(amt, c_stage)
        return amt * c_stage
    end
}


