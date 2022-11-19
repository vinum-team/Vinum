local graph = require(script.Parent.utils.graph)

local class = {}
local meta = { __index = class }

function class:_update(newValue)
	self._value = newValue

	self._graph:update(newValue)
end

function class:get()
	return self._value
end

function class:set(newValue)
	local shouldUpdate = self._updateProcessor(self._value, newValue)

	if shouldUpdate then
		self:_update(newValue)
	end
end

return function(ogValue, updateProcessor)
	local self = setmetatable({
		type = "state",
		kind = "hold",

		_value = ogValue,
		_updateProcessor = updateProcessor,
	}, meta)

	self._graph = graph(self)

	return self
end