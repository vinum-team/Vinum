--!strict
-- An operator function that writes a new value to a state struct
-- and launches an update.

local Package = script.Parent.Parent
local types = require(Package.types)
local Internal = Package.Internal
local UpdateAll = require(Internal.UpdateAll)
local Memory = Package.Memory
local Borrowed = require(Memory.Borrowed)

local function Write<T>(object: types.State<T>, newValue: T)
	-- Implementing hard-coded support for SliceOfs is awkward
	-- but its fine for now, and any change that might occur regarding this
	-- will not affect the API, so backwards compatibility wouldn't be violated.
	if object.type == "SliceOf" then
		local _object = object :: types.SliceOf
		_object._owner.value.value[_object._key] = newValue
		UpdateAll(_object._owner.node)
	else
		object.value = Borrowed(newValue)
		UpdateAll(object.node)
	end
end

return Write
