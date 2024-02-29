--!strict
local Package = script.Parent.Parent
local types = require(Package.types)

local function Derived<T, U>(scope: types.Scope<U>, computer: types.Computer<T>): types.ReactiveObject<T>
	local self = {
		type = "reactiveState" :: any,
		_computer = computer,
		scope = scope,
	}


	table.insert(scope, self)
	self.value = computer(self)
	return self
end

return Derived
