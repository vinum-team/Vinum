--!strict
local Package = script.Parent.Parent
local types = require(Package.types)

local function scoper<T>(myTable: T)
	return function(): types.Scope<T>
		return setmetatable({}, { __index = myTable }) :: any
	end
end

return scoper
