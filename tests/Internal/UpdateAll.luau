--!strict
local RNode = require("../../src/Internal/RNode")
local AddCTask = require("../../src/Internal/AddCTask")
local AddDependent = require("../../src/Internal/AddDependent")
local UpdateAll = require("../../src/Internal/UpdateAll")
local DebuggerHost = require("../../src/DebuggerHost")
local testkit = require("../../.lune/luneVendor/ecrTestKit")
local TEST, CASE, CHECK = testkit.test()

local function noop() end

TEST("Internal/UpdateAll", function()
	do
		CASE("first pass should sort all dependencies before their dependents")
		local flag = false
		local root_1 = RNode({})
		local a = RNode({})
		local b = RNode({})
		local c = RNode({})

		AddDependent(root_1, a)
		AddDependent(root_1, b)
		AddDependent(b, c)

		DebuggerHost.onFirstPass = function(DependentQueue, Length)
			CHECK(DependentQueue[1] == root_1)
			-- NOTE: Both A and B are direct dependents of root_1, so it doesn't
			-- matter which one came first.
			CHECK(DependentQueue[2] == a or DependentQueue[2] == b)
			CHECK(DependentQueue[3] == b or DependentQueue[3] == a)
			CHECK(DependentQueue[4] == c)
			flag = true
		end
		UpdateAll(false, 1, root_1)
		DebuggerHost.onFirstPass = noop
		CHECK(flag == true)
	end

	do
		CASE("second pass should simplify the sorted array inversely")
		local a = RNode({})
		local b = RNode({})
		local c = RNode({})

		AddDependent(a, b)
		AddDependent(a, c)
		AddDependent(b, c)

		local flag = false

		DebuggerHost.onSecondPass = function(DependentQueue, Length)
			CHECK(DependentQueue[3] == a)
			CHECK(DependentQueue[2] == b)
			CHECK(DependentQueue[1] == c)
			flag = true
		end
		UpdateAll(false, 1, a)
		DebuggerHost.onSecondPass = noop
		CHECK(flag == true)
	end

	do
		CASE("third pass must cancel all CTasks and run onUpdate if it exists")
		local flag = false
		local secondFlag = false
		local a = RNode({
			onUpdate = function()
				flag = true
			end,
		})

		AddCTask(a, {
			cancel = function()
				secondFlag = true
			end,
		})

		UpdateAll(false, 1, a)
		CHECK(flag == secondFlag)
		CHECK(flag == true)
	end
end)
