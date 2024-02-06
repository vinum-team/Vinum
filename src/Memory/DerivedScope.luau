--!strict
local Package = script.Parent.Parent
local types = require(Package.types)

local function DerivedScope<T, U>(myScope: types.Scope<T>, additionalConstructors: U?): types.Scope<T & U>
	local myScopeMetatable = getmetatable(myScope)
	local oldConstructors = myScopeMetatable.__index

	if additionalConstructors then
		for name, fn in additionalConstructors :: any do
			oldConstructors[name] = fn
		end
	end
	return setmetatable({}, { __index = oldConstructors }) :: any
end

return DerivedScope
