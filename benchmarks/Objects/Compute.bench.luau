local Vinum = require(game.ReplicatedStorage.Vinum)

local Hold = Vinum.Hold
local Compute = Vinum.Compute
local returner = function(value)
	return function()
		return value
	end
end
local graph = Vinum.graph
local run = graph.run

local alwaysTrue = returner(true)

return {
	{
		name = "Creating Computes with one dep",
		calls = 50000,

		preRun = function()
			local dep = Hold(1, alwaysTrue)
			return function(use)
				return use(dep)
			end
		end,
		run = function(capturer)
			Compute(capturer, alwaysTrue)
		end,
	},
	{
		name = "Updating Computes with one dep",
		calls = 50000,

		preRun = function()
			local dep = Hold(1, alwaysTrue)
			local function capturer(use)
				return use(dep)
			end
			return Compute(capturer, alwaysTrue)._graph
		end,
		run = function(obj)
			run(obj, true)
		end,
	},
	{
		name = "Updating Computes with one dep + static",
		calls = 50000,

		preRun = function()
			local dep = Hold(1, alwaysTrue)
			local function capturer(use, _, static)
				static(true)
				return use(dep)
			end
			return Compute(capturer, alwaysTrue)._graph
		end,
		run = function(obj)
			run(obj, false)
		end,
	},
}
