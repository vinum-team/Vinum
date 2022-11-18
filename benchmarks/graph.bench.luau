local graph = require(game.ReplicatedStorage.Vinum.utils.graph)



local function update(a)
    a._graph:update()
    return true
end

local function makeDependency(dependency, dependent)
    dependency._graph:addDependent(dependent)
    dependent._graph:addDependency(dependency)
end

return {
    {
        name = "updating empty tree",
        calls = 50000,

        preRun = function()
            return graph()
        end,
        run = function(graphObj)
            graphObj:update()
        end
    },
    {
        name = "updating shallow tree",
        calls = 50000,
        
        preRun = function()
            local root = graph()
            root:addDependent({_update = update , _graph = graph()})
            root:addDependent({_update = update , _graph = graph() })
            root:addDependent({_update = update , _graph = graph() })
            root:addDependent({_update = update , _graph = graph()})
            return root
        end,
        run = function(graphObj)
            graphObj:update()
        end
    },
    {
        name = "updating deep & complex tree - 7 total dependencies/dependents",
        calls = 50000,

        preRun = function()
            local root = graph()

            local A = {_update = update, _graph = graph()}
            local B = {_update = update, _graph = graph()}
            local C = {_update = update, _graph = graph()}
            local D = {_update = update, _graph = graph()}

            --[[
                root - > a = B/C => D
            ]]
            root:addDependent(A)
            root:addDependent(B)
            root:addDependent(C)

            makeDependency(A, B)
            makeDependency(A, C)
            makeDependency(B, D)
            makeDependency(C, D)

            return root
        end,

        run = function(root)
            root:update()
        end
    }
}