--!strict
local Package = script.Parent.Parent
local types = require(Package.types)

local Derived = require(Package.Creators.Derived)
local Source = require(Package.Creators.Source)
local Ref = require(Package.Creators.Ref)
local Map = require(Package.Creators.Map)

local scoper = require(Package.Memory.Scoper)
local InnerScope = require(Package.Operators.InnerScope)

local function Add(scope, thing)
	table.insert(scope, thing)

	return thing
end
local scoped = scoper({
	Derived = Derived,
	Source = Source,
	Ref = Ref,
	Map = Map,
	InnerScope = InnerScope,
	Add = Add,
})

type Scope = typeof(scoped())

local function BulkCreate<T>(fn: (T & { [any]: types.ReactiveObject<unknown, any> }, scope: Scope) -> ()): (T, Scope)
	local results = {}
	local scope = scoped()

	fn(results :: any, scope)

    return results :: any, scope
end

return BulkCreate