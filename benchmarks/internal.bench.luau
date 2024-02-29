--!strict
local UpdateAll = require("../src/Internal/UpdateAll")
local AddDependents = require("../src/Internal/AddDependent")

local testkit = require("../.lune/luneVendor/ecrTestKit")
local BENCH, START = testkit.benchmark()
local function TITLE(name: string)
	print()
	print(testkit.color.white(name))
end

local function RNode()
	return {
		value = 1,
		type = "reactiveState",
	} :: any
end

do
	TITLE("UpdateAll")
	do
		local a = RNode()
		local b = RNode()
		local root = RNode()

		AddDependents(root, a)
		AddDependents(root, b)

		BENCH("with direct dependents", function()
			for i = 1, START(20_000) do
				UpdateAll(true, 1, root)
			end
		end)
	end

	local a = RNode()
	local b = RNode()
	local root = RNode()

	AddDependents(root, a)
	AddDependents(root, b)
	AddDependents(a, RNode())
	BENCH("with nested dependents", function()
		for i = 1, START(20_000) do
			UpdateAll(true, 1, root)
		end
	end)
end
