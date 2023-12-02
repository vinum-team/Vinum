--!strict
local Compute = require(script.Creators.Compute)
local SliceOf = require(script.Creators.SliceOf)
local Value = require(script.Creators.Value)
local Ref = require(script.Creators.Ref)

local scoper = require(script.Memory.Scoper)
local scoped = scoper({
    Compute = Compute,
    SliceOf = SliceOf,
    Value = Value,
    Ref = Ref
})

return {
    Scoped = scoped,
    Read = require(script.Operators.Read),
    Write = require(script.Operators.Write),
    On = require(script.Operators.On),
    Use = require(script.Operators.Use),
    MakeOwned = require(script.Memory.MakeOwned),
    Borrowed = require(script.Memory.Borrowed),
    Kill = require(script.Memory.Kill)
}