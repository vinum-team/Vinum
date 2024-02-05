--!strict
local Package = script.Parent.Parent
local types = require(Package.types)
local Internal = Package.Internal
local RNode = require(Internal.RNode)

local function Source<T>(scope: types.Scope<any>, value: T): types.State<T>
	local self = {
		type = "Source",
		value = value,
		scope = scope,
	}

	table.insert(scope, self)
	RNode(self)
	return self
end

return Source
