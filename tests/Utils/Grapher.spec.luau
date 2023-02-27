--!strict

local Vinum = require(game.ReplicatedStorage.Vinum)
local Grapher = Vinum.Utils.grapher
local create, simplify, update, _updateDepenents =
	Grapher.create, Grapher.simplifyTreeForGraph, Grapher.updateGraph, Grapher.updateDependents

local function initBond(dependency: any, dependent: any)
	dependency.dependentSet[dependent] = true
	dependent.dependencySet[dependency] = true
end

type expect = (any) -> any
return {
	["should create a Graph without owner"] = function(expect: expect)
		local thing = create()

		expect(thing.type).to.equal("utils")
		expect(thing.kind).to.equal("graph")
		expect(thing).to.be.a("table")
	end,
	["ownerless Graph should notify its subgraphs"] = function(expect: expect)
		local graph = create()
		local flag = false
		local subGraph = create({
			_update = function()
				flag = true
			end,
		} :: any)

		initBond(graph, subGraph)
		expect(update(graph)).to.equal(true)
		expect(flag).to.equal(true)
	end,
	["Dependency tree simplification should work"] = function(expect: expect)
		local A = create()
		local B = create()
		local C = create()

		initBond(A, B)
		initBond(B, C)
		initBond(A, C)

		simplify(C)

		expect(C.dependencySet[A]).to.equal(nil)
	end,
}
