--!strict
-- A Trait is a table that relates a behavior to a value.
local Package = script.Parent.Parent
local types = require(Package.types)

local function Trait<T>(value: T, fn: (value: T) -> ()): types.Trait<T>
    return { value = value, fn = fn, type = "trait"}
end

return Trait