local Vinum = require(game.ReplicatedStorage.Vinum)
local Hold = Vinum.Objects.Hold

local function alwaysTrue(...)
    return true
end

return {
    {
        name = "hold creation",
        calls = 50_000,

        run = function()
            Hold(1, alwaysTrue)
        end
    },
    {
        name = "reading",
        calls = 50_000,

        preRun = function()
            return Hold(123, alwaysTrue)
        end,

        run = function(holder)
            return holder._value
        end,
    },
    {
        name = "writing",
        calls = 50_000,

        preRun = function()
            return Hold(100, alwaysTrue)
        end,

        run = function(holder)
            holder:_setValue(200)
        end
    }
}