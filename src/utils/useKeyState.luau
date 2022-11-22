return function(self)
	return function(state, keyName)
        local keyGraph = state._graphs[keyName]
        keyGraph._dependentSet[self] = true
    
        self._graph._dependencySet[state] = true

        return state:getKey(keyName)
	end
end
