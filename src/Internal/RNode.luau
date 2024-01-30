--!strict
local Package = script.Parent.Parent
local types = require(Package.types)

local function RNode(Owner: types.Owner, onDependentAdded): types.RNode
    return {
        owner = Owner,
        dependents = {},
        cancelableTasks = {},
        onDependentAdded = onDependentAdded
    }
end

return RNode