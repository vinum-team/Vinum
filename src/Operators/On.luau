--!strict
-- A self-aware operator that manages Listen objects.

local Package = script.Parent.Parent
local types = require(Package.types)
local Internal = Package.Internal
local Node = require(Internal.Node)
local GetState = require(Internal.GetState)
local AddDependentUtils = require(Internal.AddDependentUtils)

local function runnConnection(self)
	self._connection()

	return false
end

local function On(_, state: types.EitherState<any>, listener: () -> ())
	local _state = GetState(state)
	local listenerOwner = {
		_connection = listener,
		update = runnConnection,
	}

	listenerOwner.node = Node.Node(listenerOwner)
	AddDependentUtils.addDependent_nodes(_state.node, listenerOwner.node)

	table.insert(_state.scope, listenerOwner)
end

return On
