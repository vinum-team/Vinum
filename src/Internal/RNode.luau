--!strict
local Package = script.Parent.Parent
local types = require(Package.types)
local DebuggerHost = require(Package.DebuggerHost)

local function RNode(Owner: types.Owner, onDependentAdded): types.RNode
	local myRNode = {
		owner = Owner,
		onDependentAdded = onDependentAdded,
	}
	DebuggerHost.onRNode(myRNode)

	Owner.node = myRNode

	return myRNode
end

return RNode
