--[[
    A utility for state object deconstruction
]]
local cantReadClass = {
	__index = function()
		error("[Vinum] Object is destroyed")
	end,
}

local function destroyGraph(deconstruct, graph)
	-- STEP 1: disconnect all relations with our dependencies
	for dependency in graph.dependencySet do
		dependency.dependentSet[graph] = nil
		graph.dependencySet[dependency] = nil
	end

	-- STEP 2: deconstruct all dependents
	for dependent in graph.dependentSet do
		deconstruct(dependent._owner)
	end

	-- STEP 3: clear the graph
	table.clear(graph)
end

local function deconstruct(state)
	local processor = state._processor
	if state.behavior == "central" then
		for key, graph in state._graphs do
			destroyGraph(deconstruct, graph)
		end

		for key, value in state._values do
			processor(key, value, value, true)
		end
	else
		destroyGraph(deconstruct, state._graph)
        processor(nil, state._value, state._value, true)
	end

	table.clear(state)
	return setmetatable(state, cantReadClass)
end

return deconstruct