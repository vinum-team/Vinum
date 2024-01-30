--!strict
local Package = script.Parent.Parent
local types = require(Package.types)

local function AddDependent(dependency: types.RNode, dependent: types.RNode)
    dependency.dependents[dependent] = true

    if dependency.onDependentAdded then
        dependency.onDependentAdded(dependency, dependent)
    end
end

return AddDependent