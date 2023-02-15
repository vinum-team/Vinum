--!strict
local Utils = script.Parent
local LibraryRoot = Utils.Parent
local Types = require(LibraryRoot.types)

local function write<T>(state: Types.TAnySelfState<T>, value: T)
    return state:_setValue(value)
end

return write