
local testing = {
	hello = function(func, a, b, c)
		print(a, b, c, "here")
		
		if func then
			Timer.delayedCall(2000, function()
				func()
			end)
		end
	end,
	
	welcome = function(func, a)
		print(a .. " LOL")
		if func then
			func()
		end
	end
}

local curr = {}

function queueCommand(command, ...)
	local index = #curr + 2
	
	table.insert(curr, function()
		testing[command](function()
			if #curr >= index then
			    curr[index]()
			else
				table.remove(curr)
			end
		end, unpack(arg))
	end)
	
	if index == 2 then
		curr[1]()
	end
end

runCommand("hello", 4, 5, 6)
runCommand("welcome", 8)

runCommand("hello", 4, 10, 6)
runCommand("welcome", 9)













