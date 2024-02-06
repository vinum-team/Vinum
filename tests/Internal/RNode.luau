--!strict
local RNode = require("../../src/Internal/RNode")
local DebuggerHost = require("../../src/DebuggerHost")
local testkit = require("../../.lune/luneVendor/ecrTestKit")
local TEST, CASE, CHECK = testkit.test()

TEST("Internal/RNode", function()
	do
		CASE("must have CTasks and Dependents fields as nil on creation")
		local myRNode = RNode({})

		CHECK(myRNode.cancelableTasks == nil)
		CHECK(myRNode.dependents == nil)
	end

	do
		CASE("could have onDependentAdded as nil")
		local myRNode = RNode({})

		CHECK(myRNode.onDependentAdded == nil)
	end

	do
		CASE("must have numOfDependents as 1 on creation")
		local myRNode = RNode({})

		CHECK(myRNode.numOfDependents == 0)
	end

	do
		CASE("must add itself as `node` to Owner")
		local myOwner = {}

		CHECK((myOwner :: any).node == nil)
		local myRNode = RNode(myOwner)
		CHECK(myOwner.node == myRNode)
	end

	do
		CASE("must invoke DebuggerHost's onRNode")
		local flag = false
		local pastCallback = DebuggerHost.onRNode

		DebuggerHost.onRNode = function(myRNode)
			flag = true
		end

		RNode({})
		CHECK(flag == true)

		DebuggerHost.onRNode = pastCallback
	end

	do
		CASE("its owner must be attached to it as `owner`")
		local myOwner = {}
		local myRNode = RNode(myOwner)

		CHECK(myRNode.owner == myOwner)
	end
end)
