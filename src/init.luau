--!strict
local Compute = require(script.Creators.Compute)
local SliceOf = require(script.Creators.SliceOf)
local Value = require(script.Creators.Value)
local Ref = require(script.Creators.Ref)
local Map = require(script.Creators.Map)

local scoper = require(script.Memory.Scoper)
local InnerScope = require(script.Operators.InnerScope)

local function Add(scope, thing)
	table.insert(scope, thing)

	return thing
end
local scoped = scoper({
	Compute = Compute,
	SliceOf = SliceOf,
	Value = Value,
	Ref = Ref,
	Map = Map,
	InnerScope = InnerScope,
	Add = Add,
})

local On = require(script.Operators.On)
local Use = require(script.Operators.Use)
local Read = require(script.Operators.Read)
local Write = require(script.Operators.Write)

local Kill = require(script.Memory.Kill)

return {
	Scoped = scoped,
	On = On,
	Use = Use,
	Read = Read,
	Write = Write,
	Kill = Kill,
}
