local Vinum = require(game.ReplicatedStorage.Vinum)
local Graph = Vinum.Utils.Graph

local function initBond(dependency, dependent)
    dependency.dependentSet[dependent] = true
    dependent.dependencySet[dependency] = true
end

return {
    {
        name = "construction",
        calls = 50_000,

        run = function()
            Graph()
        end
    },
    {
        name = "simplification - the ABC triangle",
        calls = 50_000,

        preRun = function()
            local A = Graph()
            local B = Graph()
            local C = Graph()

            initBond(A, B)
            initBond(B, C)
            initBond(A, C)

            return C
        end,

        run = function(graphObj: typeof(Graph()))
            graphObj:simplifyDependencies()
        end
    },
    {
        name = "update - the ABC triangle simplified",
        calls = 50_000,

        preRun = function()
            local A = Graph()
            local B = Graph()
            local C = Graph()

            initBond(A, B)
            initBond(B, C)
            initBond(A, C)

            C:simplifyDependencies()
            return A
        end,
        run = function(root)
            root:update()
        end
    },
    {
        name = "update - the ABC triangle",
        calls = 50_000,

        preRun = function()
            local A = Graph()
            local B = Graph()
            local C = Graph()

            initBond(A, B)
            initBond(B, C)
            initBond(A, C)

            return A
        end,
        run = function(root)
            root:update()
        end
    }
}