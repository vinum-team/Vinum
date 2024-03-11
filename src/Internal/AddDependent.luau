--!strict
local Package = script.Parent.Parent
local types = require(Package.types)

type ReactiveObject = types.ReactiveObject<any, any>

local function AddDependent(dependency: ReactiveObject, dependent: ReactiveObject | () -> ())
	if not dependency.dependents then
		dependency.dependents = {}
	end
	-- FIXME: Luau doesn't understand guard statements from a typechecking point of
	-- view yet, as such, we resort to overriding the types to any.
	(dependency :: any).dependents[dependent] = true
end

return AddDependent
