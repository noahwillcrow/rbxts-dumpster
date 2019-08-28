local Dumpster = {} do
	Dumpster.__index = Dumpster

	local finalizers = {
		["function"] = function(item)
			item()
		end,
		["Instance"] = function(item)
			item:Destroy()
		end,
		["RBXScriptConnection"] = function(item)
			item:Disconnect()
		end,
		["table"] = function(item)
			item:destroy()
		end
	}

	function Dumpster.new()
		return setmetatable({}, Dumpster)
	end

	function Dumpster:dump(item)
		self[item] = finalizers[typeof(item)]
	end

	function Dumpster:burn()
		for item, finalizer in pairs(self) do
			finalizer(item)
			self[item] = nil
		end
	end
end

return Dumpster