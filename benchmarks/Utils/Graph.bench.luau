local Vinum = require(game.ReplicatedStorage.Vinum)

local Graph = Vinum.graph

local create = Graph.create
local run = Graph.run
local hasDependent = Graph.haveDependent

local function connect(dependency, dependent)
	dependency.dependents[dependent] = true
	dependent.dependencies[dependency] = true
end

local function owner()
	return {
		_update = function() end,
	}
end

return {
	{
		name = "Creating Graphs",
		calls = 50000,

		run = function()
			create(Vinum)
		end,
	},
	{
		name = "Updating a Graph with complex dependency tree and recalculation applied",
		calls = 50000,

		preRun = function()
			local root = create(owner())

			local A = create(owner())
			local B = create(owner())
			local C = create(owner())
			local D = create(owner())

			connect(root, A)
			connect(A, B)
			connect(A, C)
			connect(B, C)
			connect(C, D)
			connect(root, D)
			connect(B, D)
			return D
		end,

		run = function(d)
			run(d, true)
		end,
	},
	{
		name = "Calling haveDependent",
		calls = 50000,

		preRun = function()
			local root = create(owner())
			root.dependents[create(owner())] = true
			return root
		end,

		run = function(root)
			hasDependent(root)
		end,
	},
	{
		name = "Updating a Graph with complex dependency tree",
		calls = 50000,

		preRun = function()
			local root = create(owner())

			local A = create(owner())
			local B = create(owner())
			local C = create(owner())
			local D = create(owner())

			connect(root, A)
			connect(A, B)
			connect(A, C)
			connect(B, C)
			connect(C, D)
			connect(root, D)
			connect(B, D)
			return D
		end,

		run = function(d)
			run(d, false)
		end,
	},
}
