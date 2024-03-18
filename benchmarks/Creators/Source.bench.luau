local Vinum = require("../../src")
local testkit = require("../../.lune/luneVendor/ecrTestKit")
local BENCH, START = testkit.benchmark()
local function TITLE(name: string)
	print()
	print(testkit.color.white(name))
end

local Scope = Vinum.Scoped()
do
	TITLE("Sources")
	BENCH("Creating Sources", function()
		for i = 1, START(20_000) do
			Scope:Source(i)
		end
	end)
end
local aSource = function<T, U>(scope: U, value: T): {nil | T | U | string}
	return {
		nil,
		nil,
		nil,
		nil,
		value,
		scope,
		"reactiveState",
	}
end

local dScope = Vinum.DerivedScope(Vinum.Scoped(), {
	aSource = aSource
})
do
	TITLE("Sources array")
	BENCH("Creation", function()
		for i = 1, START(20_000) do
			dScope:aSource(i)
		end
	end)
end