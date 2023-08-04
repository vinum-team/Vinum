local Vinum = require("src-copy/init")

local Hold = Vinum.Hold
local KeyOf = Vinum.KeyOf
local returner = function(value)
	return function()
		return value
	end
end

local alwaysTrue = returner(true)

local mainStore = Hold({ hi = 1 }, alwaysTrue)

return {
	{
		name = "Creating KeyOfs",
		calls = 20000,

		run = function()
			KeyOf(mainStore, "hi", alwaysTrue)
		end,
	},
	{
		name = "Setting KeyOfs",
		calls = 20000,

		preRun = function()
			local store = Hold({ hi = 1 }, alwaysTrue)
			return KeyOf(store, "hi", alwaysTrue)
		end,
		run = function(obj)
			obj:set("hello")
		end,
	},
	{
		name = "Updating KeyOfs",
		calls = 20000,

		preRun = function()
			local store = Hold({ hi = 1 }, alwaysTrue)
			return KeyOf(store, "hi", alwaysTrue)
		end,
		run = function(obj)
			obj:_update()
		end,
	},
}
