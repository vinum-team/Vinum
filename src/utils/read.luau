--!strict
local Utils = script.Parent
local LibraryRoot = Utils.Parent
local Types = require(LibraryRoot.types)

local function read<T>(state: Types.CanBeState<T> | Types.TAnyCentralState<T> | T, key: Types.maybeStringOrNumber?): T
	if type(state) == "table" then
		local behaviorField = state.behavior
		if behaviorField == "central" then
			return (state :: Types.TAnyCentralState<T>)._values[key]
		elseif behaviorField == "self" then
			return (state :: Types.TAnySelfState<T>)._value
		else
			return (state :: any) :: T
		end
	end

	return state :: T
end

return read
