--!strict
-- A builtin function responsible for killing scopes.
local Package = script.Parent.Parent
local Internal = Package.Internal
local GetState = require(Internal.GetState)
local types = require(Package.types)

local function cancelAllCTasks(RNode: types.RNode)
	if RNode.cancelableTasks then
		for _, ctask in RNode.cancelableTasks do
			ctask:cancel()
		end

		RNode.cancelableTasks = nil
	end
end

local function Kill(scope: types.Scope<any>)
	for key, value in scope :: any do
		-- cases
		-- case 1: Vinum Structs
		local valueType = type(value)

		if valueType == "table" and value.type then
			local state = GetState(value)

			cancelAllCTasks(state.node)
			if state.scope ~= scope then
				Kill(state.scope)
			end
			continue
		end

		-- case 2: functions
		if valueType == "function" then
			value()
			continue
		end
	end

	table.clear(scope)
end

return Kill
