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
	local stateGraph = graph

	-- STEP 1: disconnect all relations with our dependencies
	for dependency: graph in stateGraph._dependencySet do
		dependency._dependentSet[stateGraph] = nil
		stateGraph._dependencySet[dependency] = nil
	end

	-- STEP 2: deconstruct all dependents
	for dependent: graph in stateGraph._dependentSet do
		deconstruct(dependent._owner)
	end

	-- STEP 3: clear the graph
	table.clear(stateGraph)
end

local function deconstruct(state: { _isSelfContained: boolean, _graph: graph, _graphs: { graph } })
	if state._isSelfContained then
		destroyGraph(deconstruct, state._graph)
	else
		for key, graph in state._graphs do
			destroyGraph(deconstruct, graph)
		end
	end

	table.clear(state)
	return setmetatable(state, cantReadClass)
end

return deconstruct
