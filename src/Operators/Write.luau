--!strict
-- An operator function that writes a new value to a state struct
-- and launches an update.

local Package = script.Parent.Parent
local types = require(Package.types)
local Internal = Package.Internal
local UpdateAll = require(Internal.UpdateAll)

local function Write<T>(object: types.ReactiveObject<T>, newValue: T)

	object.value = newValue
	UpdateAll(false, 1, object)
end

return Write
