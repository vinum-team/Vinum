local Vinum = require(game.ReplicatedStorage.Vinum)
local Compute = Vinum.Objects.Compute
local update = Vinum.Utils.Grapher.updateGraph
local function alwaysTrue(...)
	return true
end

return {
	{
		name = "construction",
		calls = 50_000,

		run = function()
			Compute(function()
				return 1
			end, alwaysTrue)
		end,
	},
	{
		name = "updating",
		calls = 50_000,

		preRun = function()
			return Compute(function()
				return 1
			end, alwaysTrue)
		end,

		run = function(t)
			update(t._graph)
		end,
	},
}
