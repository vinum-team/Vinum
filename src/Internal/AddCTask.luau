--!strict
local Package = script.Parent.Parent
local types = require(Package.types)
local DebuggerHost = require(Package.DebuggerHost)

local function addCTask(RNode: types.RNode, CTask: types.CTask)
	if not RNode.cancelableTasks then
		RNode.cancelableTasks = {}
	end

	DebuggerHost.onAddCTask(RNode, CTask)
	table.insert(RNode.cancelableTasks :: any, CTask)
end

return addCTask
