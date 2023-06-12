local Vinum = require(game.ReplicatedStorage.Vinum)

local Hold = Vinum.Hold
local returner = function(value)
    return function()
        return value
    end
end
return {
	{
		name = "Creating Holds",
		calls = 50000,

		run = function()
			Hold(1, returner(true))
		end,
	},
	{
		name = "set()'ing Holds",
		calls = 50000,

		preRun = function()
			return Hold(100, returner(true))
		end,
		run = function(holder)
			holder:set(400)
		end,
	},
	{
		name = "get()'ing Holds value",
		calls = 50000,

		preRun = function()
			return Hold(100, returner(true))
		end,
		run = function(holder)
			holder:get()
		end,
	},
}