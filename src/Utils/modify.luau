--!strict
local Utils = script.Parent
local LibraryRoot = Utils.Parent
local Types = require(LibraryRoot.types)

local function modify(
	obj: Types.TAnyState<any>,
	toBeModified: "_isWritable" | "_isYieldable" | "_static",
	value: boolean
)
	obj[toBeModified] = value
	return obj
end

return modify
