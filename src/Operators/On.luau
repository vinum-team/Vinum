--!strict
-- A self-aware operator that manages Listen objects.

local Package = script.Parent.Parent
local types = require(Package.types)
local Internal = Package.Internal
local Node = require(Internal.Node)
local getState = require(Internal.getState)

local watchedStateToListener: {[types.State<any>]: types.Listen<any>} = setmetatable({}, {_mode = "kvs"}) :: any

local function ListenUpdate(self: types.Listen<any>)
    for _, fn in self._connections do
        fn()
    end

    return false
end


local function On(state: types.EitherState<any>, listener: () -> ())
    local _state = getState(state)
    local myListener do
        if watchedStateToListener[_state]  then
            myListener = watchedStateToListener[_state]
        else
            local myState = {
                type = "Listener",
                value = {} :: any,
                _connections = {},
                update = ListenUpdate
            }

            table.insert(_state.scope, myState)
            myState.scope = _state.scope

            myState.node = Node.Node(myState)
            watchedStateToListener[_state] = myState
            myListener = myState
        end
    end

    table.insert(myListener._connections, listener)
end

return On