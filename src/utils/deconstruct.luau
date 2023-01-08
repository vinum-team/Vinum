--[[
    A utility for self-contained objects destruction. 
]]
local graph = require(script.Parent.graph)

local cantReadClass = {
	__index = function()
		error("[Vinum] Object is destroyed")
	end,
}

type graph = typeof(graph())

local function destroyGraph(deconstruct, graph)
	-- STEP 1: disconnect all relations with our dependencies
	for dependency: graph in graph._dependencySet do
		dependency._dependentSet[graph] = nil
		graph._dependencySet[dependency] = nil
	end

	-- STEP 2: deconstruct all dependents
	for dependent: graph in graph._dependentSet do
		deconstruct(dependent._owner)
	end

	-- STEP 3: clear the graph
	table.clear(graph)
end

local function deconstruct(state: { kind: string, _graph: graph, _graphs: { graph } })
	if state.kind == "group" then
		for key, graph in state._graphs do
			destroyGraph(deconstruct, graph)
		end
	else
		destroyGraph(deconstruct, state._graph)
	end

	table.clear(state)
	return setmetatable(state, cantReadClass)
end

return deconstruct
