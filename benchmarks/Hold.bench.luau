local Vinum = require(game.ReplicatedStorage.Vinum)

local Hold = Vinum.Hold
return {
	{
		name = "Creating Holds",
		calls = 50000,

		run = function()
			Hold(1, Vinum.JustOk)
		end,
	},
	{
		name = "set()'ing Holds",
		calls = 50000,

		preRun = function()
			return Hold(100, Vinum.JustOk)
		end,
		run = function(holder)
			holder:set(400)
		end,
	},
	{
		name = "get()'ing Holds value",
		calls = 50000,

		preRun = function()
			return Hold(100, Vinum.JustOk)
		end,
		run = function(holder)
			holder:get()
		end,
	},
}
