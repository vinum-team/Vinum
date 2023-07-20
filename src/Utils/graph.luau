--!strict

local types = require(script.Parent.Parent.types)

local graph = {}

function graph.create(owner): types.Graph
	return {
		type = "graph",
		owner = owner,
		dependencies = {},
		dependents = {},
		asyncOperations = {},
	}
end

function graph.isAnDependent(dependency: types.Graph, dependent: types.Graph)
	if not dependency.dependents[dependent] then
		if not graph.haveDependent(dependency) then
			return false
		end

		for dependentItem in dependency.dependents do
			return graph.isAnDependent(dependentItem, dependent)
		end
	end

	return true
end

function graph.run(graphObj: types.Graph, recalculate: boolean)
	local owner = graphObj.owner

	if owner and owner._update then
		for _, asyncOperation in graphObj.asyncOperations do
			asyncOperation:cancel()
		end

		if recalculate then
			-- clear all dependencies
			local myDependencies = graphObj.dependencies

			for dependency in myDependencies do
				dependency.dependents[graphObj] = nil
			end

			table.clear(myDependencies)

			-- recapture
			owner:_update()

			-- tree simplification
			for dependency in myDependencies do
				for anotherDependencyRef in myDependencies do
					if not graph.isAnDependent(dependency, anotherDependencyRef) then
						continue
					end

					dependency.dependents[graphObj] = nil
					graphObj.dependencies[dependency] = nil
				end
			end
		else
			owner:_update()
		end
	end

	for dependent in graphObj.dependents do
		graph.run(dependent, not dependent.owner.static)
	end
end

function graph.haveDependent(graphObj: types.Graph)
	for _ in graphObj.dependents do
		return true
	end
	return false
end

return graph
