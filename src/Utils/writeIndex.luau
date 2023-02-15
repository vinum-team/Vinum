--!strict
local Utils = script.Parent
local LibraryRoot = Utils.Parent
local Types = require(LibraryRoot.types)

local function writeIndex<T>(state: Types.TAnyCentralState<T>, index: string | number, value: T)
    return state:_setValue(index, value)
end

return writeIndex