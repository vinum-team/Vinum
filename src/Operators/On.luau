--!strict
-- A self-aware operator that manages Listen objects.

local Package = script.Parent.Parent
local types = require(Package.types)
local Internal = Package.Internal
local GetState = require(Internal.GetState)
local AddDependent = require(Internal.AddDependent)

local function On(state: types.EitherState<any>, listener: () -> ())
	local fn

	fn = function()
		listener()
		AddDependent(GetState(state), fn)
	end
	AddDependent(GetState(state), fn)
end

return On
