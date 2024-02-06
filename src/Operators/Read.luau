--!strict
-- An operator function that reads the value of either a refState or a state struct.

local Package = script.Parent.Parent
local types = require(Package.types)
local Internal = Package.Internal
local GetState = require(Internal.GetState)

local function Read<T>(object: types.EitherState<T>): T
	local state = GetState(object)
	if state.value == nil then
		state.value = (state :: any)._computer(state.node)
	end
	return state.value
end

return Read
