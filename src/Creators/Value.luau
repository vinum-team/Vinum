--!strict
local Package = script.Parent.Parent
local types = require(Package.types)
local Internal = Package.Internal
local RNode = require(Internal.RNode)
local Memory = Package.Memory
local Borrowed = require(Memory.Borrowed)

local function Value<T>(scope, value: T): types.State<T>
	local self = {
		type = "Value",
		value = Borrowed(value),
		scope = scope,
	}

	table.insert(scope, self)
	self.node = RNode(self)
	return self
end

return Value
