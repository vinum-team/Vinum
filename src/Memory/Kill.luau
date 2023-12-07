--!strict
-- A builtin function responsible for killing scopes.
local Package = script.Parent.Parent
local Internal = Package.Internal
local getState = require(Internal.getState)
local types = require(Package.types)

local function Kill(scope: types.Scope<any>)
	for _, object in scope :: any do
		if object.type then
			getState(object).value.fn(object.value.value)
		else
			Kill(object)
		end
	end
	table.clear(scope)
end

return Kill
