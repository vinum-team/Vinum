--!strict
local Derived = require(script.Creators.Derived)
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
	Source = Source,
	Ref = Ref,
	Map = Map,
	InnerScope = InnerScope,
	Add = Add,
})

local Track = require(script.Operators.Track)
local Use = require(script.Operators.Use)
local Read = require(script.Operators.Read)
local Write = require(script.Operators.Write)
local Batch = require(script.Operators.Batch)

local DerivedScope = require(script.Memory.DerivedScope)
local Kill = require(script.Memory.Kill)

return {
	Scoped = scoped,
	Track = Track,
	Use = Use,
	Read = Read,
	Write = Write,
	Kill = Kill,
	Batch = Batch,
	DerivedScope = DerivedScope,
	Version = {
		major = 0,
		minor = 5,
		patch = 0,
		dev_mode = true
	}
}
