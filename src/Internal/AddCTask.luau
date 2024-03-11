--!strict
local Package = script.Parent.Parent
local types = require(Package.types)

type ReactiveObject = types.ReactiveObject<any, any>

local function addCTask(RNode: ReactiveObject, CTask: types.CTask)
	if not RNode.cTasks then
		RNode.cTasks = {}
	end

	table.insert(RNode.cTasks :: any, CTask)
end

return addCTask
