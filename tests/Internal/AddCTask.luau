--!strict
local AddCTask = require("../../src/Internal/AddCTask")
local DebuggerHost = require("../../src/DebuggerHost")
local testkit = require("../../.lune/luneVendor/ecrTestKit")
local TEST, CASE, CHECK = testkit.test()

local function RNode()
	return {
		value = 1,
		scope = {},
		type = "reactiveState",
	} :: any
end

TEST("Internal/AddCTask", function()
	do
		CASE("must un-nilify cancelableTasks if its a nil")
		local myRNode = RNode()

		AddCTask(myRNode, {} :: any)
		CHECK(myRNode.cTasks ~= nil)
	end

	do
		CASE("must invoke DebuggerHost's onAddCTask")
		local myRNode = RNode()

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
