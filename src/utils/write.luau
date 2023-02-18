--!strict
local Utils = script.Parent
local LibraryRoot = Utils.Parent
local Types = require(LibraryRoot.types)

local function write<T>(state: Types.TAnySelfState<T>, value: T)
    if state._isWritable ~= true then
        --errr
    end
    return state:_setValue(value)
end

return write