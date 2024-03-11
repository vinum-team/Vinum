--!strict
-- An operator function that reads the value of either a refState or a state struct.

local Package = script.Parent.Parent
local types = require(Package.types)
local Internal = Package.Internal
local GetState = require(Internal.GetState)

local MiddlewareUtils = require(Internal.MiddlewareUtils)
local GlobalMiddleware = require(Package.Utility.GlobalMiddleware)

local function Read<T>(object: types.EitherState<T>): T
	local state = GetState(object)
	if state.value == nil then
		state.value = (state :: any)._computer(state)
	end
	local value = state.value

	MiddlewareUtils.execute(GlobalMiddleware["write"], value)

	return value
end

return Read
