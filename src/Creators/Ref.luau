--!strict
local Package = script.Parent.Parent
local types = require(Package.types)
local Internal = Package.Internal
local GetState = require(Internal.GetState)

local function Ref<T>(scope: types.Scope<any>, state: types.EitherState<T>): types.refState<T>
	local myState = GetState(state)
	local ref = {
		type = "refState",
		ref = myState,
	}

	table.insert(scope, ref)
	return ref :: any
end

return Ref
