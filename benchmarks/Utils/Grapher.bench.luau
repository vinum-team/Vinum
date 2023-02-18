local Vinum = require(game.ReplicatedStorage.Vinum)
local Grapher = Vinum.Utils.Grapher

local function initBond(dependency, dependent)
    dependency.dependentSet[dependent] = true
    dependent.dependencySet[dependency] = true
end

local create = Grapher.create 
local update = Grapher.updateGraph 
local simplify = Grapher.simplifyTreeForGraph

return {
    {
        name = "construction",
        calls = 50_000,

        run = function()
            create()
        end
    },
    {
        name = "simplification - the ABC triangle",
        calls = 50_000,

        preRun = function()
            local A = create()
            local B = create()
            local C = create()

            initBond(A, B)
            initBond(B, C)
            initBond(A, C)

            return C
        end,

        run = function(graphObj)
            simplify(graphObj)
        end
    },
    {
        name = "update - the ABC triangle simplified",
        calls = 50_000,

        preRun = function()
            local A = create()
            local B = create()
            local C = create()

            initBond(A, B)
            initBond(B, C)
            initBond(A, C)

            simplify(C)
            return A
        end,
        run = function(root)
            update(root)
        end
    },
    {
        name = "update - the ABC triangle",
        calls = 50_000,

        preRun = function()
            local A = create()
            local B = create()
            local C = create()

            initBond(A, B)
            initBond(B, C)
            initBond(A, C)

            return A
        end,
        run = function(root)
            update(root)
        end
    }
}