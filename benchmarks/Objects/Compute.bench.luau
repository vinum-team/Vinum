local Vinum = require("src-copy/init")

local Hold = Vinum.Hold
local Compute = Vinum.Compute
local returner = function(value)
	return function()
		return value
	end
end
local alwaysTrue = returner(true)

return {
	{
		name = "Creating Computes with one dep",
		calls = 20000,

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
		calls = 20000,

		preRun = function()
			local dep = Hold(1, alwaysTrue)
			local function capturer(use)
				return use(dep)
			end
			return Compute(capturer, alwaysTrue)
		end,
		run = function(obj)
			obj:_update()
		end,
	},
	{
		name = "Updating Computes with one dep + static",
		calls = 20000,

		preRun = function()
			local dep = Hold(1, alwaysTrue)
			local function capturer(use, _, static)
				static(true)
				return use(dep)
			end
			return Compute(capturer, alwaysTrue)
		end,
		run = function(obj)
			obj:_update()
		end,
	},
}
