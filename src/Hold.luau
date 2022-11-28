local graph = require(script.Parent.utils.graph)
local class = { type = "state", kind = "hold" }
local meta = { __index = class }

export type Hold<T> = {
	type: "state",
	kind: "hold",

	_value: T,
	_updateProcessor: (oldValue: T, newValue: T) -> (boolean),
	_graph: typeof(graph()),
	get: (self: Hold<T>) -> (T),
	set: (self: Hold<T>, newValue: T) -> (),
}

function class:get()
	return self._value
end

function class:set(newValue)
	local shouldUpdate = self._updateProcessor(self._value, newValue)

	if shouldUpdate then
		self._value = newValue

		self._graph:update(newValue)
	end
end

local function Hold<T>(ogValue: T, updateProcessor: (T, T) -> (boolean))
	local self = setmetatable({
		_value = ogValue,
		_updateProcessor = updateProcessor,
		_graph = {},
	}, meta)

	self._graph = graph(self)

	return self :: Hold<T>
end

return Hold
