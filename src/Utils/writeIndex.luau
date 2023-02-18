--!strict
local Utils = script.Parent
local LibraryRoot = Utils.Parent
local Types = require(LibraryRoot.types)

local function writeIndex<T>(state: Types.TAnyCentralState<T>, index: string | number, value: T)
    if state._isWritable ~= true then
        --errr
    end
    return state:_setValue(index, value)
end

return writeIndex