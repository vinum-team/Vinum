--!strict
-- An operator that connects a dependent to a dependency.

local Package = script.Parent.Parent
local types = require(Package.types)
local Internal = Package.Internal
local getState = require(Internal.getState)

local function Use<T>(_, dependent: types.Node, dependency: types.EitherState<T>): T
	local dependencyState = getState(dependency)
	dependencyState.node.dependents[dependent] = true
	-- FIXME: While dependency links are entirely dynamic, scope links
	-- aren't. This needs some design to find a very performant solution
	-- that doesn't overcomplicate the ocdebase and doesn't eat up
	-- performance.
	if dependencyState.scope ~= dependent.owner.scope then
		table.insert(dependencyState.scope, dependent.owner.scope)
	end
	return dependencyState.value.value
end

return Use
