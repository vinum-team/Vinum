--!strict
local Package = script.Parent.Parent
local Internal = Package.Internal
local GetState = require(Internal.GetState)
local Creators = Package.Creators
local Compute = require(Creators.Compute)
local Operators = Package.Operators
local Use = require(Operators.Use)
local types = require(Package.types)

type RNode = types.RNode

local function Map<T>(
	scope,
	myState: types.EitherState<any>,
	cases: { [any | "default"]: types.Trait<T> | types.EitherState<T> }
): types.Compute<T>
	return Compute(scope, function(Node: types.RNode)
		local myState = GetState(myState)
		local myValue = Use(Node, myState)
		local chosenArm = cases[myValue] or cases["default"]

		if chosenArm.type == "trait" then
			return chosenArm :: types.Trait<T>
		else
			local _chosenArm = GetState(chosenArm)
			Use(Node, _chosenArm)
			return _chosenArm.value
		end
	end)
end

return Map
