

function makeLeader(place, country, username, xp)
	local wrapper = makeSprite(Game.leaders)
	
	local plac = makeText(wrapper, "", 70)
	local flag = makeFlag(wrapper, "ZZ")
	local name = makeText(wrapper, "", 60)
	local exps = makeText(wrapper, "lvl 0", 60)
	
	flag:setScale(2)
	plac:setPosition(0, 95)
	flag:setPosition(100, 0)
	name:setPosition(280, 90)
	
	name:setClip(0, -100, 450, 300)
	exps:setPosition(780, 90)
	
	wrapper.setInfo = function(place, country, username, xp)
	
		plac.setText(place .. ".")
		flag.setFlag(country)
		name.setText(username)
		exps.setText("lvl " .. math.floor(math.sqrt(xp)))
	end
	
	wrapper.setInfo(place, country, username, xp)
	
	return wrapper
end