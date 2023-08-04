return {['benchmarks/Objects/Absorb.bench.luau']=function() local Vinum = require("src-copy/init")

local Hold = Vinum.Hold
local Absorb = Vinum.Absorb

local returner = function(value)
	return function()
		return value
	end
end
local alwaysTrue = returner(true)

local constant = Hold(1, alwaysTrue)
local last
return {
	{
		name = "Creating Absorb",
		calls = 20000,

		preRun = function()
			return {
				[1] = Hold(true, alwaysTrue),
			}
		end,
		run = function(caseList)
			last = Absorb(constant, caseList, alwaysTrue)
		end,

		postRun = function()
			Vinum.destroyObject(last)
		end,
	},
	{
		name = "Updating Absorb",
		calls = 20000,

		preRun = function()
			last = Absorb(constant, {
				[1] = Hold(true, alwaysTrue),
			}, alwaysTrue)

			return last
		end,
		run = function(object)
			object:_update()
		end,
		postRun = function()
			Vinum.destroyObject(last)
		end,
	},	
}
 end,['benchmarks/Objects/KeyOf.bench.luau']=function() local Vinum = require("src-copy/init")

local Hold = Vinum.Hold
local KeyOf = Vinum.KeyOf
local returner = function(value)
	return function()
		return value
	end
end

local alwaysTrue = returner(true)

local mainStore = Hold({ hi = 1 }, alwaysTrue)

return {
	{
		name = "Creating KeyOfs",
		calls = 20000,

		run = function()
			KeyOf(mainStore, "hi", alwaysTrue)
		end,
	},
	{
		name = "Setting KeyOfs",
		calls = 20000,

		preRun = function()
			local store = Hold({ hi = 1 }, alwaysTrue)
			return KeyOf(store, "hi", alwaysTrue)
		end,
		run = function(obj)
			obj:set("hello")
		end,
	},
	{
		name = "Updating KeyOfs",
		calls = 20000,

		preRun = function()
			local store = Hold({ hi = 1 }, alwaysTrue)
			return KeyOf(store, "hi", alwaysTrue)
		end,
		run = function(obj)
			obj:_update()
		end,
	},
}
 end,['benchmarks/Utils/Graph.bench.luau']=function() local Vinum = require("src-copy/init")

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
		calls = 20000,

		run = function()
			create(Vinum)
		end,
	},
	{
		name = "Updating a Graph with complex dependency tree and recalculation applied",
		calls = 20000,

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
		calls = 20000,

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
		calls = 20000,

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
 end,['benchmarks/Objects/Compute.bench.luau']=function() local Vinum = require("src-copy/init")

local Hold = Vinum.Hold
local Compute = Vinum.Compute
local returner = function(value)
	return function()
		return value
	end
end
local alwaysTrue = returner(true)

return {
	{
		name = "Creating Computes with one dep",
		calls = 20000,

		preRun = function()
			local dep = Hold(1, alwaysTrue)
			return function(use)
				return use(dep)
			end
		end,
		run = function(capturer)
			Compute(capturer, alwaysTrue)
		end,
	},
	{
		name = "Updating Computes with one dep",
		calls = 20000,

		preRun = function()
			local dep = Hold(1, alwaysTrue)
			local function capturer(use)
				return use(dep)
			end
			return Compute(capturer, alwaysTrue)
		end,
		run = function(obj)
			obj:_update()
		end,
	},
	{
		name = "Updating Computes with one dep + static",
		calls = 20000,

		preRun = function()
			local dep = Hold(1, alwaysTrue)
			local function capturer(use, _, static)
				static(true)
				return use(dep)
			end
			return Compute(capturer, alwaysTrue)
		end,
		run = function(obj)
			obj:_update()
		end,
	},
}
 end,['benchmarks/Objects/Listen.bench.luau']=function() local Vinum = require("src-copy/init")

local Hold = Vinum.Hold
local Listen = Vinum.Listen
local returner = function(value)
	return function()
		return value
	end
end

local alwaysTrue = returner(true)

local dep = Hold(1, alwaysTrue)

return {
	{
		name = "Creating Listeners",
		calls = 20000,

		run = function()
			Listen(dep, alwaysTrue)
		end,
	},
	{
		name = "Updating Listeners",
		calls = 20000,

		preRun = function()
			return Listen(Hold(1, alwaysTrue), alwaysTrue)
		end,

		run = function(obj)
			obj:_update()
		end,
	},
}
 end,['benchmarks/Objects/Hold.bench.luau']=function() local Vinum = require("src-copy/init")

local Hold = Vinum.Hold
local returner = function(value)
	return function()
		return value
	end
end

local alwaysTrue = returner(true)

return {
	{
		name = "Creating Holds",
		calls = 20000,

		run = function()
			Hold(1, alwaysTrue)
		end,
	},
	{
		name = "set()'ing Holds",
		calls = 20000,

		preRun = function()
			return Hold(100, alwaysTrue)
		end,
		run = function(holder)
			holder:set(400)
		end,
	},
	{
		name = "get()'ing Holds value",
		calls = 20000,

		preRun = function()
			return Hold(100, alwaysTrue)
		end,
		run = function(holder)
			holder:get()
		end,
	},
}
 end}