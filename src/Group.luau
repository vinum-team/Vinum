local graph = require(script.Parent.utils.graph)
local spawner = require(script.Parent.utils.spawner)
local class = {}
local meta = { __index = class }

local selfContainedClass = {__index = {
    get = function(self)
        return self._graph._owner[self.name]
    end
}}
function class:setKey(keyName, keyValue)
    if self._setProcessor(keyName, keyValue) then
        if self._values[keyName] then
            self._values[keyName] = keyValue
            self._graphs[keyName]:update(keyValue)
        else
            self._values[keyName] = keyValue
            self._graphs[keyName] = graph(self)
        end

        for connection in self._connections do
            spawner(connection, keyName, keyValue)
        end
    end
end

function class:getKey(keyName)
    return self._values[keyName]
end

function class:asState(KeyName)
    return setmetatable({name = KeyName, _graph = self._graphs[KeyName]}, selfContainedClass)
end

function class:onChange(fn)
    self._connections[fn] = true

    return function()
        self._connections[fn] = nil
    end
end

return function(setProcessor)
    local self = setmetatable({
        type = "state",
		kind = "group",

		_isStaticDependency = false,
        _isSelfContained = false,
        _setProcessor = setProcessor,
        _values = {},
        _graphs = {},
        _connections = {}
    }, meta)

    return self
end