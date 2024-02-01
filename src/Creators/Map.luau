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

--[[
			local myState = GetState(myState)
		local myValue = Use(Node, myState)
		local chosenArm = cases[myValue] or cases["default"]

		if type(chosenArm) == "table" and chosenArm.type then
			return Use(Node, GetState(chosenArm))
		else
			return chosenArm
		end
]]
local function Map<T, U>(
	scope: types.Scope<U>,
	myState: types.EitherState<any>,
	cases: { [any | "default"]: T | types.EitherState<T> }
): types.Compute<T>
	return Compute(scope, function(Node: types.RNode)
		local myValue = Use(Node, GetState(myState))
		local chosenArm = cases[myValue] or cases["default"]

		if type(chosenArm) == "table" and chosenArm.type then
			return Use(Node, GetState(chosenArm))
		else
			return chosenArm :: T
		end
	end)
end

return Map
