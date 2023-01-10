local Vinum = require(game.ReplicatedStorage.Vinum)

local Calc = Vinum.Calc
local Hold = Vinum.Hold
local AlwaysTrue = Vinum.Processors.AlwaysTrue
local read = Vinum.read
local Staticify = Vinum.Staticify
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
			read(calc)
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
		end,
	},
	{
		name = "updating a calc value with a semi-complex and static dependency tree",
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

			Staticify(B)
			return B
		end,

		run = function(root)
			root:_update()
		end,
	},
	{
		name = "updating a calc value with a lot of dependencies-packed tree",
		calls = 50000,

		preRun = function()
			local tbl = {}

			for i = 1, 10, 1 do
				table.insert(tbl, Hold(i, Vinum.Processors.AlwaysTrue))

			end
			local B = Calc(function(useState)
				for _, t in tbl do
					useState(t)
				end
				return true

			end, AlwaysTrue)
			
			Staticify(B)
			return B
		end,

		run = function(root)
			root:_update()
		end,
	},
}
