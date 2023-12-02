--!strict
-- A builtin function responsible for killing scopes.
local Package = script.Parent.Parent
local Internal = Package.Internal
local getState = require(Internal.getState)

local function Kill(scope: {any})
    for _, object in scope do
        if object.type then
            getState(object).value.fn(object.value.value)
        else
            Kill(object)
        end
    end
    table.clear(scope)
end

return Kill