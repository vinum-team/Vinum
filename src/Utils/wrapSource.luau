--!strict
local types = require("../types")
local Hold = require("../Objects/Hold")

local function wrapSource(sourceObject, handler: (old: any, new: any) -> any, processor: types.Processor<any>)
    local Holder = Hold({} :: any, processor)
    sourceObject:On(function(newArguments)
        Holder:set(handler(Holder:get(), newArguments))
    end)

    return Holder
end

return wrapSource