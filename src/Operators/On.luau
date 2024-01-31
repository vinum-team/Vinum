--!strict
-- A self-aware operator that manages Listen objects.

local Package = script.Parent.Parent
local types = require(Package.types)
local Internal = Package.Internal
local RNode = require(Internal.RNode)
local GetState = require(Internal.GetState)
local AddDependent = require(Internal.AddDependent)

local function runnConnection(self)
	self._connection()
	AddDependent(self._owner.node, self.node)
	return false
end

local function On(state: types.EitherState<any>, listener: () -> ())
	local _state = GetState(state)
	local listenerOwner = {
		_connection = listener,
		onUpdate = runnConnection,
		_owner = _state,
	}

	listenerOwner.node = RNode(listenerOwner)
	AddDependent(_state.node, listenerOwner.node)
end

return On
