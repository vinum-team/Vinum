--!strict
local types = require(script.Parent.Parent.types)
local Hold = require(script.Parent.Parent.Objects.Hold)

local function wrapSource(sourceObject, handler: (old: any, new: any) -> any, processor: types.Processor<any>)
	local Holder = Hold({} :: any, processor)
	sourceObject:On(function(newArguments)
		Holder:set(handler(Holder:get(), newArguments))
	end)

	return Holder
end

return wrapSource
