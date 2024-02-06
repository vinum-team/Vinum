--!strict
local RNode = require("../../src/Internal/RNode")
local AddCTask = require("../../src/Internal/AddCTask")
local DebuggerHost = require("../../src/DebuggerHost")
local testkit = require("../../.lune/luneVendor/ecrTestKit")
local TEST, CASE, CHECK = testkit.test()

TEST("Internal/AddCTask", function()
	do
		CASE("must un-nilify cancelableTasks if its a nil")
		local myRNode = RNode({})

		AddCTask(myRNode, {} :: any)
		CHECK(myRNode.cancelableTasks ~= nil)
	end

	do
		CASE("must invoke DebuggerHost's onAddCTask")
		local myRNode = RNode({})

		local pastCallback = DebuggerHost.onAddCTask
		local flag = false

		DebuggerHost.onAddCTask = function()
			flag = true
		end

		AddCTask(myRNode, {} :: any)
		CHECK(flag == true)

		DebuggerHost.onAddCTask = pastCallback
	end
end)
