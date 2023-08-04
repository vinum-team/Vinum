local Vinum = require("src-copy/init")

local Hold = Vinum.Hold
local returner = function(value)
	return function()
		return value
	end
end

local alwaysTrue = returner(true)

return {
	{
		name = "Creating Holds",
		calls = 20000,

		run = function()
			Hold(1, alwaysTrue)
		end,
	},
	{
		name = "set()'ing Holds",
		calls = 20000,

		preRun = function()
			return Hold(100, alwaysTrue)
		end,
		run = function(holder)
			holder:set(400)
		end,
	},
	{
		name = "get()'ing Holds value",
		calls = 20000,

		preRun = function()
			return Hold(100, alwaysTrue)
		end,
		run = function(holder)
			holder:get()
		end,
	},
}
