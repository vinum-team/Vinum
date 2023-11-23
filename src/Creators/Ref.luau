--!strict
local Package = script.Parent.Parent
local types = require(Package.types)
local Internal = Package.Internal
local getState = require(Internal.getState)

local function Ref<T>(state: types.EitherState<T>): types.refState<T>
    return {
        type = "refState",
        ref = getState(state)
    }
end

return Ref