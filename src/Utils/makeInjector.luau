--!strict

local types = require(script.Parent.Parent.types)

return function(graph: types.Graph)
	return function<T>(obj: types.StateObj<any, T>): T
		local objGraph = obj._graph
		objGraph.dependents[graph] = true
        
        -- we could potentially support constant dependencies 
        -- by omitting this line to make it invisible to the dependency manager
		graph.dependencies[objGraph] = true

		return obj:get()
	end
end
