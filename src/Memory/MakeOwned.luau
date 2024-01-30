--!strict
-- A Trait contructor that creates a trait with pre-configured behavior

local Package = script.Parent.Parent
local types = require(Package.types)
local Memory = Package.Memory
local Trait = require(Memory.Trait)

local function MakeOwned<T>(fn: (value: T) -> ())
	return function(value: T): types.Trait<T>
		return Trait(value, fn)
	end
end

return MakeOwned
