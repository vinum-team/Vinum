--!strict
local Package = script.Parent.Parent
local types = require(Package.types)
local Internal = Package.Internal
local RNode = require(Internal.RNode)
local GetState = require(Internal.GetState)
local AddDependent = require(Internal.AddDependent)

local function SliceOfUpdater(self: types.SliceOf)
	self.value = self._owner.value[self._key]
	AddDependent(self._owner.node, self.node)
	return true
end

local function SliceOf(scope, state: types.EitherState<{ [any]: any }>, Key: any): types.SliceOf
	local _state = GetState(state)
	local self = {
		type = "SliceOf",
		value = {},
		onUpdate = SliceOfUpdater,
		_owner = _state,
		_key = Key,
		scope = scope,
	}

	self.node = RNode(self :: any)
	AddDependent(_state.node, self.node)

	return self
end

return SliceOf
