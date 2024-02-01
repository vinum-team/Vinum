--!strict
local Package = script.Parent.Parent
local types = require(Package.types)
local Internal = Package.Internal
local RNode = require(Internal.RNode)

local function ComputeUpdater<T>(self: types.Compute<T>)
	self.value = self._computer(self.node)
	return true
end

local function Compute<T, U>(scope: types.Scope<U>, computer: types.Computer<T>): types.Compute<T>
	local self = {
		type = "Compute",
		value = 0 :: any,
		onUpdate = ComputeUpdater,
		_computer = computer,
		scope = scope,
		node = 0 :: any
	}

	RNode(self :: any)

	table.insert(scope, self)
	self.value = computer(self.node)
	return self
end

return Compute
