local read = require(script.Parent.read)

return function(self)
	local selfGraph = self._graph
	return function(state)
		local stateGraph = state._graph
		stateGraph._dependentSet[selfGraph] = true
		selfGraph._dependencySet[stateGraph] = true
		return read(state)
	end
end
