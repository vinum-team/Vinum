--!strict
local Vinum = require("../../src")
local Ops = Vinum.Operators
local Memos = Vinum.Memos
local Scoped = Vinum.Scoped

local task = require("@lune/task")
return {
    should_test = function(_, expect)
        local scope = Scoped()

        local numberStream = scope:Stream(function(send)
            send(20)
            task.delay(2, send, 10)
        end)
        local runs = 0

        Ops:On(numberStream, function()  
            runs += 1
        end)
        Ops:On(numberStream, function()  
            runs += 1
        end)

        task.wait(3)
        expect(runs).to.equal(4)
    end
}