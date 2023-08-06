local Vinum = require(game.ReplicatedStorage.Vinum)

local Hold = Vinum.Hold
local Absorb = Vinum.Absorb

local returner = function(value)
	return function()
		return value
	end
end
local alwaysTrue = returner(true)

local constant = Hold(1, alwaysTrue)

return {
	{
		name = "Creating Absorb",
		calls = 50000,

		preRun = function()
			return {
				[1] = Hold(true, alwaysTrue),
			}
		end,
		run = function(caseList)
			Absorb(constant, caseList, alwaysTrue)
		end,
	},
	{
		name = "Updating Absorb",
		calls = 50000,

		preRun = function()
			return Absorb(constant, {
				[1] = Hold(true, alwaysTrue),
			}, alwaysTrue)
		end,
		run = function(object)
			object:_update()
		end,
	},
}
