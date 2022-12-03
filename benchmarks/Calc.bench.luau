local Vinum = require(game.ReplicatedStorage.Vinum)

local Hold = Vinum.Hold
local Calc = Vinum.Calc
local AlwaysTrue = Vinum.AlwaysTrue

return {
	{
		name = "creating a calc object",
		calls = 50000,

		run = function()
			Calc(function()
				return true
			end, AlwaysTrue)
		end,
	},
	{
		name = "getting a calc value",
		calls = 50000,

		preRun = function()
			return Calc(function()
				return true
			end, AlwaysTrue)
		end,

		run = function(calc)
			calc:get()
		end,
	},
	{
		name = "updating a calc value with a semi-complex dependency tree",
		calls = 50000,

		preRun = function()
			local root = Calc(function()
				return 1
			end, AlwaysTrue)
			local A = Calc(function(useState)
				return useState(root) + 1
			end, AlwaysTrue)
			local B = Calc(function(useState)
				return useState(A) + useState(root)
			end, AlwaysTrue)

			return B
		end,

		run = function(root)
			root:_update()
		end
	},
}
