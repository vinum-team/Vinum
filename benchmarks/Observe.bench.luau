local Vinum = require(game.ReplicatedStorage.Vinum)

local Hold = Vinum.Hold 
local Observe = Vinum.Observe 
local JustOk = Vinum.JustOk

return {
    {
        name = "creating an Observe object",
        calls = 50000,

        preRun = function()
            return Hold(100, JustOk)
        end,
        run = function(Holder)
            Observe(Holder, JustOk)
        end
    },
    {
        name = "firing an Observe object with 5 connections",
        calls = 50000,

        preRun = function()
            local root = Hold(100, JustOk)
            local observer = Observe(root, JustOk)

            for i = 1, 5 do
                observer:onChange(function()
                end)
            end

            return observer
        end,

        run = function(observer)
            observer:_update(20)
        end
    }
}