--!strict
-- A Trait contructor that creates a trait with no behavior.

local Package = script.Parent.Parent
local types = require(Package.types)
local Memory = Package.Memory
local Trait = require(Memory.Trait)

local function fn() end

local function Borrowed<T>(value: T): types.Trait<T>
	return Trait(value, fn)
end

return Borrowed
