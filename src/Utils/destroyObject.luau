--!strict
local types = require(script.Parent.Parent.types)

local function destroyObject(stateObject: types.StateObj<any, any>)
	-- STEP 1: destroy the value that the object is currently holding
	stateObject._processor(stateObject._value, nil, true)

	-- STEP 2: disconnect all relations with the state object's graph's dependencies
	local myGraph = stateObject._graph
	for dependency in myGraph.dependencies do
		dependency.dependents[myGraph] = nil
		myGraph.dependencies[dependency] = nil
	end

	-- STEP 3: destroy all dependents and async operations
	for dependent in myGraph.dependents do
		destroyObject(dependent.owner)
	end

    for _, asyncOperation in myGraph.asyncOperations do
        asyncOperation:cancel()
    end

	-- STEP 4: clean the state's table, and set a non-read metatable on it.
	table.clear(stateObject)
    
	return setmetatable(stateObject, {
		__index = function()
			error("[Vinum] Object is destroyed")
		end,
	})
end


return destroyObject