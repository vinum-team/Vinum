--!strict

local types = require(script.Parent.Parent.types)

local function staticInjector(graph: types.Graph)
	return function(isStatic: boolean)
		graph.owner.static = isStatic
	end
end

return staticInjector
