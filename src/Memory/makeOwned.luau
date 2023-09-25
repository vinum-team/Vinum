--!strict
local Package = script.Parent.Parent
local Types = require(Package.types)

local Memory = Package.Memory
local isDesTrait = require(Memory.isDestrait)

local function makeOwned(cleaner: (self: Types.DesTrait<any>) -> ())
    return function<T>(value: T): Types.DesTrait<T>
        if isDesTrait(value) then
            error("Attempting to own an already owned Value.")
        end
        return {value = value, clean = cleaner}
    end
end

return makeOwned