local Vinum = require(game.ReplicatedStorage.Vinum)

local Group = Vinum.Group
local Calc = Vinum.Calc
local AlwaysTrue = Vinum.AlwaysTrue

return {
	{
		name = "creating a group object",
		calls = 50000,

		run = function()
			Group(AlwaysTrue)
		end,
	},
	{
		name = "getting a value",
		calls = 50000,

		preRun = function()
			local root = Group(AlwaysTrue)
			root:setKey("x", true)

			return root
		end,
		run = function(root)
			root:getKey("x")
		end,
	},
	{
		name = "setting groups",
		calls = 50000,

		preRun = function()
			return Group(AlwaysTrue)
		end,

		run = function(r)
			r:setKey("j", true)
		end,
	},
}
