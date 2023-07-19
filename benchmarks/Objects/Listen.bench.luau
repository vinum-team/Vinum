local Vinum = require(game.ReplicatedStorage.Vinum)

local Hold = Vinum.Hold
local Listen = Vinum.Listen
local returner = function(value)
    return function()
        return value
    end
end

local alwaysTrue = returner(true)

local dep = Hold(1, alwaysTrue)

return {
	{
		name = "Creating Listeners",
		calls = 50000,

		run = function()
			Listen(dep, alwaysTrue)
		end,
	},
    {
		name = "Updating Listeners",
		calls = 50000,

		preRun = function()
			return Listen(Hold(1, alwaysTrue), alwaysTrue)
		end,
        
        run = function(obj)
            obj:_update()
        end
	},
}