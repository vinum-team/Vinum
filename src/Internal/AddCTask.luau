--!strict
local Package = script.Parent.Parent
local types = require(Package.types)
local DebuggerHost = require(Package.DebuggerHost)

local function addCTask(RNode: types.ReactiveObject<any>, CTask: types.CTask)
	if not RNode.cTasks then
		RNode.cTasks = {}
	end

	DebuggerHost.onAddCTask(RNode, CTask)
	table.insert(RNode.cTasks :: any, CTask)
end

return addCTask
