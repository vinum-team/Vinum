--!strict
local Vinum = require("../../src")
local Ops = Vinum.Operators
local Memos = Vinum.Memos
local Scoped = Vinum.Scoped

return {
    should_work = function(_, expect)
        local scope = Scoped()

        local numberChannel = scope:Channel(function(channel)
            for i = 1, 10 do
                Ops:Write(channel, i)
            end
        end)

        Ops:On(numberChannel, function()  
            print("hi")
        end)

    end
}