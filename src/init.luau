--!strict
local Compute = require(script.Creators.Compute)
local SliceOf = require(script.Creators.SliceOf)
local Value = require(script.Creators.Value)
local Ref = require(script.Creators.Ref)
local Map = require(script.Creators.Map)
local Channel = require(script.Creators.Channel)

local scoper = require(script.Memory.Scoper)
local scoped = scoper({
	Compute = Compute,
	SliceOf = SliceOf,
	Value = Value,
	Ref = Ref,
	Map = Map,
	Channel = Channel
})

local On = require(script.Operators.On)
local Use = require(script.Operators.Use)
local Read = require(script.Operators.Read)
local Write = require(script.Operators.Write)

local Operators = {
	Read = Read,
	Write = Write,
	On = On,
	Use = Use,
}

local MakeOwned = require(script.Memory.MakeOwned)
local Borrowed = require(script.Memory.Borrowed)
local Kill = require(script.Memory.Kill)

local Memos = {
	MakeOwned = MakeOwned,
	Borrowed = Borrowed,
	Kill = Kill,
}

return {
	Scoped = scoped,
	Operators = Operators,
	Memos = Memos,
}
