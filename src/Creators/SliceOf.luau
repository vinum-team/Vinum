--!strict
local Package = script.Parent.Parent
local types = require(Package.types)
local Internal = Package.Internal
local Node = require(Internal.Node)
local getState = require(Internal.getState)

local function SliceOfUpdater(self: types.SliceOf)
    self.value = self._owner.value[self._key]
    return true
end

local function SliceOf(scope, state: types.EitherState<{[any]: any}>, Key: any): types.SliceOf
    local _state = getState(state)
    local self = {
        type = "SliceOf",
        value = {} :: any,
        update = SliceOfUpdater,
        _owner = _state,
        _key = Key,
        scope = scope
    }

    self.node = Node.Node(self)
    _state.node.dependents[self.node] = true

    return self
end

return SliceOf