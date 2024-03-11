--!strict
local AddCTask = require("../../src/Internal/AddCTask")
local testkit = require("../../.lune/luneVendor/ecrTestKit")
local TEST, CASE, CHECK, FINISH = testkit.test()

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
end)

FINISH()
