--!strict
-- An operator that connects a dependent to a dependency.

local Package = script.Parent.Parent
local types = require(Package.types)
local Internal = Package.Internal
local GetState = require(Internal.GetState)
local AddDependent = require(Internal.AddDependent)

local Read = require(script.Parent.Read)

type RNode = types.RNode
local function Use<T>(dependent: RNode, dependency: types.EitherState<T>): T
	local dependencyState = GetState(dependency)

	AddDependent(dependencyState.node, dependent)
	
	if dependencyState.scope ~= dependent.owner.scope then
		table.insert(dependencyState.scope, dependent.owner.scope)
	end
	return Read(dependencyState)
end

return Use
