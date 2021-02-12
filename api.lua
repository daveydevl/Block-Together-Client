local endpoint = "http://block-together.appspot.com/api.php"
local version = 1

api_key = ""

local file = io.open("|D|api_key.txt", "r")

if file ~= nil then
	api_key = file:read("*all")
	file:close()
end

local cmdQueue = {}

cmd = setmetatable({}, {
	__index = function(arr, command)
		return function(...)
			local index = #cmdQueue + 2
			
			arg = arg or {}
			
			table.insert(cmdQueue, function()
				commands[command](function()
					if #cmdQueue >= index then
						cmdQueue[index]()
					else
						cmdQueue = {}
					end
				end, unpack(arg))
			end)
			
			if index == 2 then
				cmdQueue[1]()
			end
		end
	end
})

api = setmetatable({key = api_key}, {
	__index = function(arr, method)
		return function(...)
			cmd.showSpinner()
			
			local function retry(msg)
				cmd.hideSpinner()
			
				local dialog = AlertDialog.new("Oops", msg, "Retry")
		
				dialog:addEventListener(Event.COMPLETE, function()
					wait(1, function()
						api[method](unpack(arg))
					end)
				end)
				
				dialog:show()
			end
		
			local data = json.encode({
				api_key = api_key,
				method = method,
				params = arg,
				v = version
			})
			
			local loader = UrlLoader.new(endpoint, UrlLoader.POST, {
				["Content-Type"] = "application/json"
			}, data)
			
			loader:addEventListener(Event.COMPLETE, function(event)
				local bool, result = pcall(json.decode, event.data)
				if not bool then
					retry("The server responded with something strange. Retry?")
					return
				end
				
				local len = #result
			
				for i = 1, len do
					local method = result[i].method
					
					if commands[method] == nil then
						cmd.error("The method `" .. method .. "` not found.")
						return
					end
					
					cmd[method](unpack(result[i].params))
				end
				
				cmd.hideSpinner()
			end)
			
			loader:addEventListener(Event.ERROR, function()
				retry("Unable to connect to the server. Please check your network connection settings and click retry!")
			end)
		end
	end
})
