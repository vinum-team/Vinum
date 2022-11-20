--!optimize 2
local shouldBenchmark = true
local shouldTest = true

local Tester = require(script.Parent.Tester)
local LuauBencher = require(script.Parent.LuauBencher)
if shouldTest then
    Tester.bootstrapper:start({
        directories = {game.ReplicatedStorage.tests},
        options = {
            context = Tester
        }
    })
end

if shouldBenchmark then
    task.wait(5)
    LuauBencher.bootstrapper.run({
        directories = {game.ReplicatedStorage.benchmarks}
    })
end