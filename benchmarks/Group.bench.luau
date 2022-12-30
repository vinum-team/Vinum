local Vinum = require(game.ReplicatedStorage.Vinum)

local Group = Vinum.Group
local AlwaysTrue = Vinum.AlwaysTrue
local emptyInitalState = {}
local read = Vinum.read
local write = Vinum.write

return {
	{
		name = "creating a group object",
		calls = 50000,

		run = function()
			Group(emptyInitalState, AlwaysTrue)
		end,
	},
	{
		name = "reading operation",
		calls = 50000,

		preRun = function()
			local root = Group({
				x = true,
			}, AlwaysTrue)
			return root
		end,
		run = function(root)
			read(root, "x")
		end,
	},
	{
		name = "writing operation",
		calls = 50000,

		preRun = function()
			return Group(emptyInitalState, AlwaysTrue)
		end,

		run = function(r)
			write(r, "j", true)
		end,
	},
}
