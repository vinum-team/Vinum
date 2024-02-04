--!strict
local Package = script.Parent.Parent
local types = require(Package.types)
local Internal = Package.Internal
local RNode = require(Internal.RNode)
local GetState = require(Internal.GetState)
local AddDependent = require(Internal.AddDependent)

local function SelectUpdater(self: types.Select)
	self.value = self._owner.value[self._key]
	AddDependent(self._owner.node, self.node)
	return true
end

local function Select(scope, state: types.EitherState<{ [any]: any }>, Key: any): types.Select
	local _state = GetState(state)
	local self = {
		type = "Select",
		value = 0 :: any,
		onUpdate = SelectUpdater :: any,
		_owner = _state,
		_key = Key,
		scope = scope,
	}

	self.node = RNode(self)
	AddDependent(_state.node, self.node)

	return self
end

return Select
