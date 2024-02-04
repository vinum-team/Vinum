--!strict
local Package = script.Parent.Parent
local types = require(Package.types)
local Internal = Package.Internal
local RNode = require(Internal.RNode)

local function Value<T>(scope, value: T): types.State<T>
	local self = {
		type = "Value",
		value = value,
		scope = scope,
	}

	table.insert(scope, self)
	self.node = RNode(self)
	return self
end

return Value
