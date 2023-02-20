--!strict
local Utils = script.Parent
local LibraryRoot = Utils.Parent
local Types = require(LibraryRoot.types)

local function writeIndex<T>(state: Types.TAnyCentralState<T>, index: string | number, value: T)
	if state._isWritable ~= true or state._setValue == nil then
		error(`[Vinum] object whose type of {state.type} doesn't allow write operations`)
	end
	return state:_setValue(index, value)
end

return writeIndex
