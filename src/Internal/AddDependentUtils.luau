--!strict
local Package = script.Parent.Parent
local types = require(Package.types)
local Internal = Package.Internal
local GetState = require(Internal.GetState)

local function addDependent_nodes(dependencyNode: types.Node, dependentNode: types.Node)
	dependencyNode.dependents[dependentNode] = true
	if dependencyNode.dependentAdded then
		(dependencyNode :: any):dependentAdded()
	end
end

local function addDependent_eitherStates(dependency: types.EitherState<unknown>, dependent: types.EitherState<unknown>)
	addDependent_nodes(GetState(dependency).node, GetState(dependent).node)
end

return {
	addDependent_nodes = addDependent_nodes,
	addDependent_eitherStates = addDependent_eitherStates,
}
