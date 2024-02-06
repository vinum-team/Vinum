--!strict
local Package = script.Parent.Parent
local types = require(Package.types)
local Internal = Package.Internal
local RNode = require(Internal.RNode)

local function DerivedUpdater<T>(self: types.Derived<T>)
	self.value = self._computer(self.node)

	return true
end

local function Derived<T, U>(scope: types.Scope<U>, computer: types.Computer<T>): types.Derived<T>
	local self = {
		type = "Derived",
		value = nil :: any,
		onUpdate = DerivedUpdater :: any,
		_computer = computer,
		scope = scope,
		node = nil :: any,
	}

	RNode(self)

	table.insert(scope, self)
	self.value = computer(self.node)
	return self
end

return Derived
