return function(self)
	local selfGraph = self._graph
	return function(state, keyName)
		local keyGraph = state._graphs[keyName]
		keyGraph._dependentSet[self._graph] = true

		selfGraph._dependencySet[keyGraph] = true
		return state:getKey(keyName)
	end
end
