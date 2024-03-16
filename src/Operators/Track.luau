--!strict
-- A self-aware operator that manages Listen objects.

local Package = script.Parent.Parent
local types = require(Package.types)
local Internal = Package.Internal
local GetState = require(Internal.GetState)
local AddDependent = require(Internal.AddDependent)

local function disconnecter(myState: types.ReactiveObject<any, any>, listener)
	return function()
		if myState.dependents then
			myState.dependents[listener] = nil
		end
	end
end

local function Track(state: types.EitherState<any>, listener: () -> ())
	local fn
	local myState = GetState(state)
	fn = function()
		listener()
		AddDependent(myState, fn)
	end
	AddDependent(myState, fn)

	return disconnecter(myState :: any, fn)
end

return Track
