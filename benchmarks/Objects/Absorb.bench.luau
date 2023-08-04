local Vinum = require("src-copy/init")

local Hold = Vinum.Hold
local Absorb = Vinum.Absorb

local returner = function(value)
	return function()
		return value
	end
end
local alwaysTrue = returner(true)

local constant = Hold(1, alwaysTrue)
local last
return {
	{
		name = "Creating Absorb",
		calls = 20000,

		preRun = function()
			return {
				[1] = Hold(true, alwaysTrue),
			}
		end,
		run = function(caseList)
			last = Absorb(constant, caseList, alwaysTrue)
		end,

		postRun = function()
			Vinum.destroyObject(last)
		end,
	},
	{
		name = "Updating Absorb",
		calls = 20000,

		preRun = function()
			last = Absorb(constant, {
				[1] = Hold(true, alwaysTrue),
			}, alwaysTrue)

			return last
		end,
		run = function(object)
			object:_update()
		end,
		postRun = function()
			Vinum.destroyObject(last)
		end,
	},	
}
