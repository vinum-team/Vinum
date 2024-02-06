--!strict
local RNode = require("../../src/Internal/RNode")
local AddDependent = require("../../src/Internal/AddDependent")
local DebuggerHost = require("../../src/DebuggerHost")
local testkit = require("../../.lune/luneVendor/ecrTestKit")
local TEST, CASE, CHECK = testkit.test()

TEST("Internal/AddDependent", function()
	do
		CASE("must un-nilify dependents if its a nil")
		local myRNode = RNode({})
		local myRNode2 = RNode({})

		AddDependent(myRNode, myRNode2)
		CHECK(myRNode.dependents ~= nil)
	end

	do
		CASE("must invoke DebuggerHost's onAddDependent")
		local myRNode = RNode({})
		local myRNode2 = RNode({})

		local pastCallback = DebuggerHost.onAddDependent
		local flag = false

		DebuggerHost.onAddDependent = function()
			flag = true
		end

		AddDependent(myRNode, myRNode2)
		CHECK(flag == true)

		DebuggerHost.onAddDependent = pastCallback
	end

	do
		CASE("must invoke a RNode onDependentAdded (with the correct arguments) if its not a nil")
		local dependencyA, dependentA
		local myRNode = RNode({}, function(dependency, dependent)
			dependencyA = dependency
			dependentA = dependent
		end)
		local myRNode2 = RNode({})
		AddDependent(myRNode, myRNode2)

		CHECK(dependencyA == myRNode)
		CHECK(dependentA == myRNode2)
	end

	do
		CASE("must increment the numOfDependents")
		local myRNode = RNode({})
		local myRNode2 = RNode({})

		AddDependent(myRNode, myRNode2)
		CHECK(myRNode.numOfDependents == 1)
	end
end)
