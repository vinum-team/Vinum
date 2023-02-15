--!optimize 2
local shouldBenchmark = true
local shouldTest = true

local Tester = require(script.Parent.Tester)
local LuauBencher = require(script.Parent.LuauBencher)

print("8")

if shouldBenchmark then
	print("Benchmarking...")
	task.wait(5)
	LuauBencher.bootstrapper.run({
		directories = { game.ReplicatedStorage.benchmarks },
	})
end

if shouldTest then
	Tester.bootstrapper:start({
		directories = { game.ReplicatedStorage.tests },
		options = {
			context = Tester,
		},
	})
end
