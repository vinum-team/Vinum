--!strict
local Package = script.Parent.Parent
local types = require(Package.types)
local Internal = Package.Internal
local Node = require(Internal.Node)
local GetState = require(Internal.GetState)
local AddDependentUtils = require(Internal.AddDependentUtils)
local Memory = Package.Memory
local Borrowed = require(Memory.Borrowed)

local function SliceOfUpdater(self: types.SliceOf)
	self.value.value = self._owner.value.value[self._key]
	return true
end

local function SliceOf(scope, state: types.EitherState<{ [any]: any }>, Key: any): types.SliceOf
	local _state = GetState(state)
	local self = {
		type = "SliceOf",
		value = Borrowed(nil, {}),
		update = SliceOfUpdater,
		_owner = _state,
		_key = Key,
		scope = scope,
	}

	self.node = Node.Node(self)
	AddDependentUtils.addDependent_nodes(_state.node, self.node)

	return self
end

return SliceOf
