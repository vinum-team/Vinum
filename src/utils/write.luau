--!strict
local Utils = script.Parent
local LibraryRoot = Utils.Parent
local Types = require(LibraryRoot.types)

local function write<T>(state: Types.TAnySelfState<T>, value: T)
	if state._isWritable ~= true or state._setValue == nil then
		error(`[Vinum] object whose type of {state.type} doesn't allow write operations`)
	end
	return state:_setValue(value)
end

return write
