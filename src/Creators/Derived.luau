--!strict
local Package = script.Parent.Parent
local types = require(Package.types)

local function Derived<T, U, D>(scope: types.Scope<U>, computer: types.Computer<T, D>, arg: D?): types.ReactiveObject<T, D>
	local self = {
		type = "reactiveState" :: any,
		_computer = computer,
		scope = scope,
		_arg = arg,
	}

	table.insert(scope, self)
	self.value = computer(self, arg or (nil :: any))
	return self
end

return Derived
