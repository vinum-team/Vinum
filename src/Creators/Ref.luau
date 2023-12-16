--!strict
local Package = script.Parent.Parent
local types = require(Package.types)
local Internal = Package.Internal
local getState = require(Internal.getState)

local function Ref<T>(scope, state: types.EitherState<T>): types.refState<T>
	local myState = getState(state)

	-- Any Ref'ed states are technically dependencies from scopes' point of view
	-- and so we kill our scope when myState's scope is killed.
	if myState.scope ~= scope then
		table.insert(myState.scope, scope)
	end
	return {
		type = "refState",
		ref = myState,
	}
end

return Ref
