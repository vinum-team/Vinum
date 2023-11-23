--!strict
local Package = script.Parent.Parent
local types = require(Package.types)
local Internal = Package.Internal
local Node = require(Internal.Node)

local function ComputeUpdater<T>(self: types.Compute<T>)
    self.value = self._computer(self.node)
    return true
end
local function Compute<T>(computer: (Node: types.Node) -> (T)): types.Compute<T>
    local self = {
        type = "Compute",
        value = 0 :: any,
        update = ComputeUpdater,
        _computer = computer
    }

    self.node = Node.Node(self)
    self.value = computer(self.node)
    return self :: any
end

return Compute