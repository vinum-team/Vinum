local graph = require(script.Parent.utils.graph)
local class = {}
local meta = { __index = class }

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
		type = "state",
		kind = "hold",

		_value = ogValue,
		_updateProcessor = updateProcessor,
		_graph = {}
	}, meta)

	self._graph = graph(self)

	return self
end

return Hold