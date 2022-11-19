local Vinum = require(game.ReplicatedStorage.Vinum)

local Hold = Vinum.Hold
local Calc = Vinum.Calc
local JustOk = Vinum.JustOk

return {
	{
		name = "creating a calc object",
		calls = 50000,

		run = function()
			Calc(function()
				return true
			end, JustOk)
		end,
	},
	{
		name = "getting a calc value",
		calls = 50000,

		preRun = function()
			return Calc(function()
				return true
			end, JustOk)
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
			end, JustOk)
			local A = Calc(function(useState)
				return useState(root) + 1
			end, JustOk)
			local B = Calc(function(useState)
				return useState(A) + useState(root)
			end, JustOk)

			return root
		end,

		run = function(root)
			root:_update()
		end
	},
}
