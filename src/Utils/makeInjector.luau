--!strict

local types = require("../types")

local function makeInjector(graph: types.Graph)
	return function<T>(obj: types.StateObj<any, T>): T
		local myGraphObject = graph.owner

		if not myGraphObject.static then
			local objGraph = obj._graph
			objGraph.dependents[graph] = true

			graph.dependencies[objGraph] = true
		end
		return obj._value
	end
end


return makeInjector