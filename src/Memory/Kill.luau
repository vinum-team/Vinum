--!strict
-- A builtin function responsible for killing scopes.
local Package = script.Parent.Parent
local Internal = Package.Internal
local GetState = require(Internal.GetState)
local types = require(Package.types)

type ReactiveObject = types.ReactiveObject<any, any>

local function cancelAllCTasks(RNode: ReactiveObject)
	if RNode.cTasks then
		for _, ctask in RNode.cTasks do
			ctask:cancel()
		end

		RNode.cTasks = nil
	end
end

local function doCleanup(task)
	local taskType = typeof(task)
	if taskType == "Instance" then
		task:Destroy()
	elseif taskType == "RBXScriptConnection" then
		task:Disconnect()
	elseif taskType == "function" then
		(task :: any)()
	elseif taskType == "table" then
		if typeof(task.destroy) == "function" then
			task:destroy()
		elseif typeof(task.Destroy) == "function" then
			task:Destroy()
		elseif task[1] ~= nil then
			for _, subtask in task do
				doCleanup(subtask)
			end
		end
	end
end

local function Kill(scope: types.Scope<any>)
	for _, value in scope :: any do
		-- cases
		-- case 1: Vinum Structs
		local valueType = type(value)

		if valueType == "table" and value.type then
			local state = GetState(value)
			cancelAllCTasks(state)
			state.value = nil

			if not state.dependents then
				continue
			end

			for child: types.ReactiveObject<any, any> in (state :: any).dependents do
				if type(child) == "function" then
					continue
				end
				if child.scope ~= scope then
					Kill(child.scope)
				end
			end
			continue
		end
		
		doCleanup(value)
	end

	table.clear(scope)
end

return Kill
