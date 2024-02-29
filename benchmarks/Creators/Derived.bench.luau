--!strict
local Vinum = require("../../src")
local testkit = require("../../.lune/luneVendor/ecrTestKit")
local BENCH, START = testkit.benchmark()
local function TITLE(name: string)
	print()
	print(testkit.color.white(name))
end

local Scope = Vinum.Scoped()

do
	TITLE("Derived")
	BENCH("Creating Deriveds", function()
		for i = 1, START(20_000) do
			Scope:Derived(function(RNode)
				return 1
			end)
		end
	end)

	BENCH("Updating Deriveds", function()
		local v = Scope:Derived(function(RNode)
			return 1
		end)

		for i = 1, START(20_000) do
			(v :: any)._computer(v)
		end
	end)
end
