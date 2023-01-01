local Vinum = require(game.ReplicatedStorage.Vinum)

local Hold = Vinum.Hold
local read = Vinum.read
local write = Vinum.write

return {
	{
		name = "Creating Holds",
		calls = 50000,

		run = function()
			Hold(1, Vinum.Processors.AlwaysTrue)
		end,
	},
	{
		name = "set()'ing Holds",
		calls = 50000,

		preRun = function()
			return Hold(100, Vinum.Processors.AlwaysTrue)
		end,
		run = function(holder)
			write(holder, 400)
		end,
	},
	{
		name = "get()'ing Holds value",
		calls = 50000,

		preRun = function()
			return Hold(100, Vinum.Processors.AlwaysTrue)
		end,
		run = function(holder)
			read(holder)
		end,
	},
}
