--!strict
local Package = script.Parent.Parent
local types = require(Package.types)
local Internal = Package.Internal
local RNode = require(Internal.RNode)
local Memory = Package.Memory
local Borrowed = require(Memory.Borrowed)

local function ComputeUpdater<T>(self: types.Compute<T>)
	self.value.fn(self.value.value)
	self.value = self._computer(self.node)
	return true
end

local function Compute<T>(scope, computer: types.Computer<T>): types.Compute<T>
	local self = {
		type = "Compute",
		value = Borrowed(0 :: any),
		onUpdate = ComputeUpdater,
		_computer = computer,
		scope = scope,
	}

	table.insert(scope, self)
	self.node = RNode(self :: any)
	self.value = computer(self.node)
	return self
end

return Compute
