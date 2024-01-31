--!strict
local UpdateAll = require("../src/Internal/UpdateAll")
local RNode = require("../src/Internal/RNode")

local testkit = require("../.lune/luneVendor/ecrTestKit")
local BENCH, START = testkit.benchmark()
local function TITLE(name: string)
	print()
	print(testkit.color.white(name))
end

do
	TITLE("UpdateAll")
	do
		local a = RNode({})
		local b = RNode({})
		local root = RNode({})

		root.dependents[a] = true
		root.dependents[b] = true

		BENCH("with direct dependents", function()
			for i = 1, START(20_00) do
				UpdateAll(root, true)
			end
		end)
	end

	local a = RNode({})
	local b = RNode({})
	local root = RNode({})

	root.dependents[a] = true
	root.dependents[b] = true
	a.dependents[RNode({})] = true
	BENCH("with nested dependents", function()
		for i = 1, START(20_00) do
			UpdateAll(root, true)
		end
	end)
end
