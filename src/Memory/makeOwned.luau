--!strict
local Package = script.Parent.Parent
local Types = require(Package.types)

local function makeOwned(cleaner: (self: Types.DesTrait<any>) -> ())
    return function<T>(value: T): Types.DesTrait<T>
        return {value = value, clean = cleaner}
    end
end

return makeOwned