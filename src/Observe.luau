local graph = require(script.Parent.utils.graph)
local class = {}
local meta = { __index = class }


function class:_update(newValue)
    if not self._updateProcessor(newValue) then return end

	for connection in self._connections do
		task.spawn(connection, newValue)
	end
end

function class:onChange(funct)
    self._connections[funct] = true

    return function()
        self._connections[funct] = nil
    end
end

return function(state, updateProcessor)
	local self = setmetatable({
		type = "state",
		kind = "observe",

        _updateProcessor = updateProcessor,
		_connections = {},
		_graph = graph(),
	}, meta)

	self._graph:addDependency(state)
	state._graph:addDependent(self)
	return self
end
