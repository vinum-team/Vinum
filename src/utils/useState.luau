return function(self)
	return function(state)
		state._graph._dependentSet[self._graph] = true
		self._graph._dependencySet[state._graph] = true
		return state:get()
	end
end
