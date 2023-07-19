--!strict

local types = require(script.Parent.Parent.types)

return function(graph: types.Graph)
	return function(isStatic: boolean)
		graph.owner.static = isStatic
	end
end
