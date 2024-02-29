--!strict
local Package = script.Parent.Parent
local types = require(Package.types)

local function Source<T>(scope: types.Scope<any>, value: T): types.ReactiveObject<T>
	local self = {
		type = "reactiveState" :: any,
		value = value,
		scope = scope,
	} :: types.ReactiveObject<T>

	table.insert(scope, self)
	return self
end

return Source
