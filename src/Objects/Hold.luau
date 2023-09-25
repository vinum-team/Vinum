--!strict
local graph = require(script.Parent.Parent.Internal.graph)
local setmetatable = require(script.Parent.Parent.Internal.setmetatable)
local pubTypes = require(script.Parent.Parent.pubTypes)
local types = require(script.Parent.Parent.types)

local class = {}
local meta = { __index = class }

type Hold = pubTypes.Hold<any>

function class.set(self: Hold, value)
	if not self._processor(self._value, value, false) then
		return
	end

	self._value = value

	graph.run(self._graph, false, true)
end

function class.get(self: Hold)
	return self._value
end

return function<T>(newValue: T, processor: types.Processor<T>): pubTypes.Hold<T>
	local self = setmetatable({
		_value = newValue,
		meta = "Hold",
		static = true,
		_processor = processor,
		_writable = true,
	}, meta) :: Hold


	self._graph = graph.create(self)

	return self
end
