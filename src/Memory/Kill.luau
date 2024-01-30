--!strict
-- A builtin function responsible for killing scopes.
local Package = script.Parent.Parent
local Internal = Package.Internal
local GetState = require(Internal.GetState)
local types = require(Package.types)

local function Kill(scope: types.Scope<{}>)
	for _, object in scope :: any do
		if object.type and object.value then
			local _object = GetState(object)
			_object.value.fn(_object.value.value)
			-- the object and _object are both real states
			if object == _object then
				table.clear(_object)
			else
				--the object is a ref state while _object is the referenced state
				table.clear(_object)
				table.clear(object)
			end
		else
			Kill(object)
		end
	end
	table.clear(scope)
end

return Kill
