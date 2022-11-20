return function(self)
	return function(state)
		state._graph._dependentSet[self] = true
		self._graph._dependencySet[state] = true
		return state:get()
	end
end
