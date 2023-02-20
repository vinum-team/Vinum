local Vinum = require(game.ReplicatedStorage.Vinum)
local Hold = Vinum.Objects.Hold
local Observe = Vinum.Objects.Observe

local function alwaysTrue(...)
	return true
end

local holder = Hold(100, alwaysTrue)

return {
	{
		name = "Observe creation",
		calls = 50_000,

		run = function()
			Observe(holder, alwaysTrue)
		end,
	},
	{
		name = "Observe update",
		calls = 50_000,

		preRun = function()
			local observer = Observe(holder, alwaysTrue)

			for i = 1, 5 do
				observer:onChange(function() end)
			end

			return observer
		end,

		run = function(observer)
			observer:_update()
		end,
	},
}
