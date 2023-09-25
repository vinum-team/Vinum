--!strict
local Package = script.Parent.Parent
local Types = require(Package.types)

local Memory = Package.Memory
local isDesTrait = require(Memory.isDestrait)

local function noOp() end

local function Borrowed<T>(value: Types.DesTrait<T> | T): Types.DesTrait<T>
	if isDesTrait(value) then
		value = (value:: Types.DesTrait<T>).value
	end
	return { value = value, clean = noOp } :: any 
end

return Borrowed
