--!strict
-- An operator that connects a dependent to a dependency.

local Package = script.Parent.Parent
local types = require(Package.types)
local Internal = Package.Internal
local GetState = require(Internal.GetState)
local AddDependent = require(Internal.AddDependent)

local Read = require(script.Parent.Read)

type ReactiveObject = types.ReactiveObject<any, any>
local function Use<T>(dependent: ReactiveObject, dependency: types.EitherState<T>): T
	local dependencyState = GetState(dependency)

	AddDependent(dependencyState, dependent)

	return Read(dependencyState)
end

return Use
