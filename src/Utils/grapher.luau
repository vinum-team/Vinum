--!strict
local Utils = script.Parent
local LibraryRoot = Utils.Parent
local Types = require(LibraryRoot.types)

local function updateGraph(graph: Types.TGraphNode): boolean
    if not graph.active then
        return false
    end
    local success = true
    local owner = graph.owner
    local shouldSimplify
    if owner and owner._update then
        if owner._static then
            success = owner:_update()
        else
            local myDependencies = graph.dependencySet
            -- STEP 1: Disable all dependencies
            for obj in myDependencies do
                myDependencies[obj] = nil
                obj.dependentSet[graph] = nil
            end

            -- STEP 2: run the owner's _update method
            success, shouldSimplify = owner:_update()

            -- STEP 3: Simplify the dependency tree

            if shouldSimplify then
                for dependency in myDependencies do
                    for upperDependency in dependency.dependencySet do
                        if not myDependencies[upperDependency] then
                            continue
                        end

                        myDependencies[upperDependency] = nil
                        upperDependency.dependentSet[graph] = nil
                    end
                end
            end
        end
    end

    if success then
        for dependent in graph.dependentSet do
            updateGraph(dependent)
        end
    end
    return success
end

local function updateDependents(graph: Types.TGraphNode)
    for dependent in graph.dependentSet do
        updateGraph(dependent)
    end
end


local function simplifyTreeForGraph(graph: Types.TGraphNode)
    local myDependencies = graph.dependencySet
    for dependency in myDependencies do
        for upperDependency in dependency.dependencySet do
            if not myDependencies[upperDependency] then
                continue
            end

            myDependencies[upperDependency] = nil
            upperDependency.dependentSet[graph] = nil
        end
    end
end

local function create(owner: Types.TAnyState<any>?): Types.TGraphNode
    return {
        type = "utils",
        kind = "graph",
        owner = owner,
        dependencySet = { },
        dependentSet = { },
        active = true,
    }
end

return {
    create = create,
    updateGraph = updateGraph,
    simplifyTreeForGraph = simplifyTreeForGraph,
    updateDependents = updateDependents
}