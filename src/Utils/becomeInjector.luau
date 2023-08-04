--!strict

local types = require("../types")

local function becomeInjector(graph: types.Graph)
    local owner = graph.owner
	return function(value)
        if not owner._writable then
            owner._writable = true
		    owner:set(value)
            owner._writable = false
            return 
        end

        owner:set(value)
	end
end

return becomeInjector