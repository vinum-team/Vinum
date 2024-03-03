--!strict
local AddDependent = require("../../src/Internal/AddDependent")
local DebuggerHost = require("../../src/DebuggerHost")
local testkit = require("../../.lune/luneVendor/ecrTestKit")
local TEST, CASE, CHECK, FINISH = testkit.test()

local function RNode()
	return {
		value = 1,
		scope = {},
		type = "reactiveState",
	} :: any
end

TEST("Internal/AddDependent", function()
	do
		CASE("must un-nilify dependents if its a nil")
		local myRNode = RNode()
		local myRNode2 = RNode()

		AddDependent(myRNode, myRNode2)
		CHECK(myRNode.dependents ~= nil)
	end

	do
		CASE("must invoke DebuggerHost's onAddDependent")
		local myRNode = RNode()
		local myRNode2 = RNode()

		local pastCallback = DebuggerHost.onAddDependent
		local flag = false

		DebuggerHost.onAddDependent = function()
			flag = true
		end

		AddDependent(myRNode, myRNode2)
		CHECK(flag == true)

		DebuggerHost.onAddDependent = pastCallback
	end
end)

FINISH()