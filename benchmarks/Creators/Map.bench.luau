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
	TITLE("Map")
	BENCH("Creating Maps", function()
		local dep = Scope:Source(1)

		local cases = {
			[1] = dep,
			["default"] = Scope:Source(1),
		}

		for i = 1, START(20_000) do
			Scope:Map(dep, cases)
		end
	end)

	BENCH("Updating Maps", function()
		local dep = Scope:Source(1)

		local state = Scope:Map(dep, {
			[1] = dep,
			["default"] = Scope:Source(1),
		})

		for i = 1, START(20_000) do
			state.onUpdate(state)
		end
	end)
end
