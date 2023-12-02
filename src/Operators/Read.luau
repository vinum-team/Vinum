--!strict
-- An operator function that reads the value of either a refState or a state struct.

local Package = script.Parent.Parent
local types = require(Package.types)
local Internal= Package.Internal
local getState = require(Internal.getState)

local function Read<T>(object: types.EitherState<T>): T
    return getState(object).value.value
end

return Read
