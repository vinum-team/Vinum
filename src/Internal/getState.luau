--!strict
local Package = script.Parent.Parent
local types = require(Package.types)

local function GetState<T>(x: types.EitherState<T>): types.ReactiveObject<T, any>
	if x.type == "refState" then
		return (x :: any).ref
	else
		return x
	end
end

return GetState
