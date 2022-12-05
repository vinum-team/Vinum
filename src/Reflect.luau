local graph = require(script.Parent.utils.graph)
local class = { type = "state", kind = "reflect" }
local meta = { __index = class }

export type Reflect<T> = {
	type: "state",
	kind: "reflect",
	_owner: { _value: T, [any]: any },
    _graph: typeof(graph()),
    get: (self: Reflect<T>) -> (T)
}

function class:get()
	return self._owner:get()
end

local function Reflect<T>(state: { _value: T, [any]: any })
	local self = setmetatable({
		_owner = state,
		_graph = state._graph,
	}, meta)
	return self :: Reflect<T>
end

return Reflect
