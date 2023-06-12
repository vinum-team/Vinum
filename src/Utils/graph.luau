--!strict

local types = require(script.Parent.Parent.types)

local graph = {}

function graph.create(owner): types.Graph
    return {
        type = "graph",
        owner = owner,
        dependencies = {},
        dependents = {}
    }
end

function graph.run(graphObj: types.Graph, recalculate: boolean)
    local owner = graphObj.owner

    if owner and owner._update then
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
                for upperDependency in dependency.dependencies do
                    if not myDependencies[upperDependency] then
                        continue
                    end

                    myDependencies[upperDependency] = nil
                    upperDependency.dependents[graphObj] = nil
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

return graph