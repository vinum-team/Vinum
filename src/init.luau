--!strict
local Derived = require(script.Creators.Derived)
local Select = require(script.Creators.Select)
local Source = require(script.Creators.Source)
local Ref = require(script.Creators.Ref)
local Map = require(script.Creators.Map)

local scoper = require(script.Memory.Scoper)
local InnerScope = require(script.Operators.InnerScope)

local function Add(scope, thing)
	table.insert(scope, thing)

	return thing
end
local scoped = scoper({
	Derived = Derived,
	Select = Select,
	Source = Source,
	Ref = Ref,
	Map = Map,
	InnerScope = InnerScope,
	Add = Add,
})

local On = require(script.Operators.On)
local Use = require(script.Operators.Use)
local Read = require(script.Operators.Read)
local Write = require(script.Operators.Write)
local Batch = require(script.Operators.Batch)

local DerivedScope = require(script.Memory.DerivedScope)
local Kill = require(script.Memory.Kill)

return {
	Scoped = scoped,
	On = On,
	Use = Use,
	Read = Read,
	Write = Write,
	Kill = Kill,
	Batch = Batch,
	DerivedScope = DerivedScope,
}
