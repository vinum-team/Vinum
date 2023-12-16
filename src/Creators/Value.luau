--!strict
local Package = script.Parent.Parent
local types = require(Package.types)
local Internal = Package.Internal
local Node = require(Internal.Node)
local Memory = Package.Memory
local Borrowed = require(Memory.Borrowed)

local function Value<T>(scope, value: T): types.State<T>
	local self = {
		type = "Value",
		value = Borrowed(nil, value),
		scope = scope,
	}

	table.insert(scope, self)
	self.node = Node.Node(self)
	return self
end

return Value
