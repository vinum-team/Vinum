--!strict
local Package = script.Parent.Parent
local Types = require(Package.types)

local function noOp()
end

local function Borrowed<T>(value: T): Types.DesTrait<T>
    return {value = value, clean = noOp}
end

return Borrowed