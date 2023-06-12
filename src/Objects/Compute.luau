--!strict
local graph = require(script.Parent.Parent.Utils.graph)
local pubTypes = require(script.Parent.Parent.pubTypes)
local types = require(script.Parent.Parent.types)
local makeInjector = require(script.Parent.Parent.Utils.makeInjector)

local class = {}
local meta = { __index = class }


function class:_update()
	local value = self._computer(self._inject)
	if not self._processor(self._value, value, false) then
		return
	end

	self._value = value
end

function class:get()
	return self._value
end

return function<T, U>(
	computer: (inject: pubTypes.inject<U>) -> (T),
	processor: types.Processor<T>
) : pubTypes.Compute<T,U>
	local self = (
		setmetatable({
			meta = "Compute",
			static = false,
			_computer = computer,
			_processor = processor
		}, meta) :: any
	) :: pubTypes.Compute<T,U>
	local myGraph = graph.create(self)
	self._graph = myGraph
	self._inject = makeInjector(myGraph)

	graph.run(myGraph, true)
	return self
end
