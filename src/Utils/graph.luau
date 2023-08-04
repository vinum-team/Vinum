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
	if graph.haveDependent(dependency) then
		if dependency.dependents[dependent] then
			return true
		end
		
		for dependencyDependent in dependency.dependents do
			local result = graph.isAnDependent(dependencyDependent, dependent)
			if result then
				return result
			end
		end
	end

	return false
end

function graph.run(graphObj: types.Graph, recalculate: boolean, shouldOnlyUpdateDependents: boolean)
	local owner = graphObj.owner

	if owner and owner._update and not shouldOnlyUpdateDependents then
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
		graph.run(dependent, not dependent.owner.static, false)
	end
end

function graph.haveDependent(graphObj: types.Graph)
	for _ in graphObj.dependents do
		return true
	end
	return false
end

return graph
