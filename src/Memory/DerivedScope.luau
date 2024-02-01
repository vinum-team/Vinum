--!strict
local Package = script.Parent.Parent
local types = require(Package.types)

local function DerivedScope<T>(myScope: types.Scope<T>): types.Scope<T>
	return setmetatable({}, getmetatable(myScope)) :: any
end

return DerivedScope
