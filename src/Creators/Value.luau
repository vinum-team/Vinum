--!strict
local Package = script.Parent.Parent
local types = require(Package.types)
local Internal = Package.Internal
local Node = require(Internal.Node)

local function Value<T>(value: T): types.State<T>
    local self = {
        type = "Value",
        value = value,
    }

    self.node = Node.Node(self)
    return self
end

return Value