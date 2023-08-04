--!strict
--An injector that manages async operations that are running during an object's update.
local types = require("../types")

local function asyncInjector(graph: types.Graph)
	return function(operation: types.AsyncOperation<any>): types.AsyncOperation<any>
		table.insert(graph.asyncOperations, operation)

		return operation
	end
end

return asyncInjector