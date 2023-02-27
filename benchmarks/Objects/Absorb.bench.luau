local Vinum = require(game.ReplicatedStorage.Vinum)
local Hold = Vinum.Objects.Hold
local Absorb = Vinum.Objects.Absorb
local update = Vinum.Utils.grapher.updateGraph
local function alwaysTrue(...)
	return true
end

local toAbsorb = Hold(100, alwaysTrue)
local isSynced = Hold(true, alwaysTrue)
local caseList = {
	[100] = Hold(100, alwaysTrue),
	["default"] = function()
		return 200
	end,
}

return {
	{
		name = "creation",
		calls = 50_000,

		run = function()
			Absorb(toAbsorb, caseList, isSynced, alwaysTrue)
		end,
	},
	{
		name = "updating",
		calls = 50_000,

		preRun = function()
			return Absorb(toAbsorb, caseList, isSynced, alwaysTrue)
		end,

		run = function(absorber)
			update(absorber._graph)
		end,
	},
}
