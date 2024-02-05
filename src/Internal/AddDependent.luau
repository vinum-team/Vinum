--!strict
local Package = script.Parent.Parent
local types = require(Package.types)
local DebuggerHost = require(Package.DebuggerHost)

local function AddDependent(dependency: types.RNode, dependent: types.RNode)
	if not dependency.dependents then
		dependency.dependents = {}
	end
	-- FIXME: Luau doesn't understand guard statements from a typechecking point of
	-- view yet, as such, we resort to overriding the types to any.
	(dependency :: any).dependents[dependent] = true
	dependency.numOfDependents += 1

	DebuggerHost.onAddDependent(dependency, dependent)
	if dependency.onDependentAdded then
		dependency.onDependentAdded(dependency, dependent)
	end
end

return AddDependent
