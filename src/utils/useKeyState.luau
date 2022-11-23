return function(self)
	return function(state, keyName)
        local keyGraph = state._graphs[keyName]
        keyGraph._dependentSet[self._graph] = true
    
        self._graph._dependencySet[keyGraph] = true

        return state:getKey(keyName)
	end
end
