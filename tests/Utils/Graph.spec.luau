--!strict

local Vinum = require(game.ReplicatedStorage.Vinum)
local Graph = Vinum.Utils.Graph


local function initBond(dependency: any, dependent: any)
    dependency.dependentSet[dependent] = true
    dependent.dependencySet[dependency] = true
end

type expect = (any) -> (any)
return {
	["should create a Graph without owner"] = function(expect: expect)
		local thing = Graph()

		expect(thing.type).to.equal("utils")
        expect(thing.kind).to.equal("graph")
        expect(thing).to.be.a("table")
	end,
    ["ownerless Graph should notify its subgraphs"] = function(expect: expect)
        local graph = Graph()
        local flag = false
        local subGraph = Graph({
            _update = function(self)
                flag = true
            end
        }::any)
        
        initBond(graph, subGraph)
        expect(graph:update()).to.equal(true)
        expect(flag).to.equal(true)
    end,
    ["Dependency tree simplification should work"] = function(expect: expect)
        local A = Graph()
        local B = Graph()
        local C = Graph()

        initBond(A, B)
        initBond(B, C)
        initBond(A, C)

        C:simplifyDependencies()

        expect(C.dependencySet[A]).to.equal(nil)
    end
}
