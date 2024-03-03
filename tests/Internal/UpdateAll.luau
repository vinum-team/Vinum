--!strict
local AddDependent = require("../../src/Internal/AddDependent")
local UpdateAll = require("../../src/Internal/UpdateAll")
local testkit = require("../../.lune/luneVendor/ecrTestKit")
local TEST, CASE, CHECK, FINISH = testkit.test()

local function noop() end
local function RNode()
	return {
		value = 1,
		scope = {},
		type = "reactiveState",
	} :: any
end

TEST("Internal/UpdateAll", function()
	do
		CASE("must update a list of trees")
		local root = RNode()
		local A = RNode()
		local B = noop

		local runs = 0

		A._computer = function(self)
			runs += 1
			return runs
		end

		AddDependent(root, A)
		AddDependent(root, B)

		UpdateAll(false, true, 1, root)

		CHECK(runs == 1)
	end
end)

FINISH()