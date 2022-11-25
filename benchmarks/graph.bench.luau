local graph = require(game.ReplicatedStorage.Vinum.utils.graph)

local function makeDependency(dependency, dependent)
    dependency:addDependent(dependent)
    dependent:addDependency(dependency)
end

return {
    {
        name = "updating empty tree",
        calls = 50000,

        preRun = function()
            return graph({})
        end,
        run = function(graphObj)
            graphObj:update()
        end
    },
    {
        name = "updating shallow tree",
        calls = 50000,
        
        preRun = function()
            local root = graph({})
            root:addDependent(graph({}))
            root:addDependent(graph({}))
            root:addDependent(graph({}))
            root:addDependent(graph({}))
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
            local root = graph({})

            local A = graph({})
            local B = graph({})
            local C = graph({})
            local D = graph({})

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
    },
    {
        name = "simplifing complex dependency tree",
        calls = 50000,

        preRun = function()
            local root = graph({})

            local A = graph({})
            local B = graph({})
            local C = graph({})
            local D = graph({})

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

            return D
        end,

        run = function(d)
            d:simplifyDependencyTree()
        end
    }
}