--!strict
local Package = script.Parent.Parent
local Internal = Package.Internal
local GetState = require(Internal.GetState)
local Creators = Package.Creators
local Derived = require(Creators.Derived)
local Operators = Package.Operators
local Use = require(Operators.Use)
local types = require(Package.types)

type RNode = types.ReactiveObject<any>

local function Map<T, U>(
	scope: types.Scope<any>,
	myState: types.EitherState<U>,
	cases: { [U]: T | types.EitherState<T> }
): types.ReactiveObject<T>
	return Derived(scope, function(Node)
		local myValue = Use(Node, GetState(myState))
		local chosenArm = cases[myValue] or cases["default" :: any]

		if type(chosenArm) == "table" and chosenArm.type then
			return Use(Node, GetState(chosenArm))
		else
			return chosenArm :: T
		end
	end)
end

return Map
