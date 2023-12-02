--!strict
-- An operator that connects a dependent to a dependency.

local Package = script.Parent.Parent
local types = require(Package.types)
local Internal = Package.Internal
local getState = require(Internal.getState)

local function Use<T>(dependent: types.Node, dependency: types.EitherState<T>): T
    local dependencyState = getState(dependency)
    dependencyState.node.dependents[dependent] = true
    if dependencyState.scope ~= dependent.owner.scope then
        table.insert(dependencyState.scope, dependent.owner.scope)
    end
    return dependencyState.value.value
end

return Use