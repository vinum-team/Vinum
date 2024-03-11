--!strict
-- An operator function that writes a new value to a state struct
-- and launches an update.

local Package = script.Parent.Parent
local types = require(Package.types)
local Internal = Package.Internal
local UpdateAll = require(Internal.UpdateAll)
local MiddlewareUtils = require(Internal.MiddlewareUtils)
local GlobalMiddleware = require(Package.Utility.GlobalMiddleware)

local function Write<T>(object: types.ReactiveObject<T, any>, newValue: T)
	if not MiddlewareUtils.execute(GlobalMiddleware["write"], newValue) then
		return
	end
	object.value = newValue
	UpdateAll(false, false, 1, object)
end

return Write
