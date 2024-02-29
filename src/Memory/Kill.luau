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

local function Kill(scope: types.Scope<any>)
	for key, value in scope :: any do
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

			for child in state.dependents do
				if type(child) == "function" then
					continue
				end
				if child.scope ~= scope then
					Kill(child.scope)
				end
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
