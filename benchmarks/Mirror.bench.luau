local Vinum = require(game.ReplicatedStorage.Vinum)

local Hold = Vinum.Hold
local Mirror = Vinum.Mirror
local AlwaysTrue = Vinum.Processors.AlwaysTrue

return {
	{
		name = "creating a mirror object",
		calls = 50000,

		preRun = function()
			return Hold(true, AlwaysTrue), Hold(false, AlwaysTrue)
		end,

		run = function(x, y)
			Mirror(x, {
				["default"] = y,
			})
		end,
	},
	{
		name = "updating a mirror object",
		calls = 50000,

		preRun = function()
			local x = Hold(true, AlwaysTrue)
			local y = Hold(false, AlwaysTrue)

			local miObj = Mirror(x, {
				["default"] = y,
			})

			miObj._currentCaseDependency = Hold("hi", AlwaysTrue)
			return miObj
		end,

		run = function(miObj)
			miObj:_update()
		end,
	},
}
