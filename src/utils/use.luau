local read = require(script.Parent.read)

return function(self)
	local selfGraph = self._graph
	return function(dependency, keyName: string? | number?)
		-- if the dependency is a group and the keyName argument is provided
		if dependency.behavior == "center" and keyName then
			local keyGraph = dependency._graphs[keyName]
			keyGraph._dependentSet[self._graph] = true
			selfGraph._dependencySet[keyGraph] = true

			return read(dependency, keyName)
		else -- this means that our dependency is a self-contained
			local stateGraph = dependency._graph
			stateGraph._dependentSet[selfGraph] = true
			selfGraph._dependencySet[stateGraph] = true

			return read(dependency)
		end
	end
end
