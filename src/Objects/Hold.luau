--!strict
local graph = require(script.Parent.Parent.Utils.graph)
local pubTypes = require(script.Parent.Parent.pubTypes)
local types = require(script.Parent.Parent.types)

local class = {}
local meta = { __index = class }

function class:set(value)
	if not self._processor(self._value, value, false) then
		return
	end

	self._value = value

	graph.run(self._graph, false)
end

function class:get()
	return self._value
end

return function<T>(newValue: T, processor: types.Processor<T>): pubTypes.Hold<T>
	local self = setmetatable({
		_value = newValue,
		meta = "Hold",
		static = true,
		_processor = processor,
	}, meta)

	self._graph = graph.create(self)

	return self :: any
end
