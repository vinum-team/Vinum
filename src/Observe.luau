local graph = require(script.Parent.utils.graph)
local spawner = require(script.Parent.utils.spawner)
local class = {}
local meta = { __index = class }


function class:_update(newValue)
	if not self._updateProcessor(newValue) then
		return
	end

	for connection in self._connections do
		spawner(connection, newValue)
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

		_isSelfContained = false,
		_updateProcessor = updateProcessor,
		_connections = {},
		_graph = {}
	}, meta)

	self._graph = graph(self)

	self._graph._dependencySet[state._graph] = true
	state._graph._dependentSet[self._graph] = true
	return self
end
