--!strict
local Package = script.Parent.Parent
local types = require(Package.types)

type ReactiveObject<T> = types.ReactiveObject<T, any>

local function Source<T>(scope: types.Scope<any>, value: T): ReactiveObject<T>
	local self = {
		type = "reactiveState" :: any,
		value = value,
		scope = scope,
	} :: ReactiveObject<T>

	table.insert(scope, self)
	return self
end

return Source
