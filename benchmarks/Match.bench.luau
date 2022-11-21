local Vinum = require(game.ReplicatedStorage.Vinum)

local Hold = Vinum.Hold
local Match = Vinum.Match
local Calc = Vinum.Calc
local JustOk = Vinum.JustOk

return {
	{
		name = "creating a Match object",
		calls = 50000,

		preRun = function()
			return Hold(100, JustOk)
		end,
		run = function(i)
			Match(i, {
				["default"] = function()
					return true
				end,
			}, JustOk)
		end,
	},
    {
        name = "updating a Match with a semi-complex dependency tree", 
        calls = 50000,
        preRun = function()
            local i = Hold(100, JustOk)

            
            local root = Calc(function(useState)
                return 3
            end, JustOk)

            local d = Calc(function(useState)
                return useState(root) * 2
            end, JustOk)

            return  Match(i, {
				["default"] = function(useState)
					return useState(root) * useState(d)
				end,
			}, JustOk)
        end,
        run = function(i)
            i:_update()
        end
    }
}
