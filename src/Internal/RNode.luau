--!strict
local Package = script.Parent.Parent
local types = require(Package.types)

local function RNode(Owner: types.Owner, onDependentAdded): types.RNode
	local myRNode = {
		owner = Owner,
		dependents = {},
		cancelableTasks = {},
		onDependentAdded = onDependentAdded,
	}

	Owner.node = myRNode

	return myRNode
end

return RNode
