--!strict
local graph = require(script.Parent.Parent.Utils.graph)
local pubTypes = require(script.Parent.Parent.pubTypes)
local types = require(script.Parent.Parent.types)
local makeInjector = require(script.Parent.Parent.Utils.makeInjector)

return function(handler: (self: pubTypes.Absorb<any, any>, inject: pubTypes.inject<any>) -> any)
	local class = {}
	local meta = { __index = class }

	function class:get()
		return self._value
	end

	function class:_update()
		local value = handler(self, self._inject)
		if not self._processor(self._value, value, false) then
			return
		end

		self._value = value
	end

	return function<T, U>(
		toAbsorb: types.StateObj<any, any>,
		cases: { [any]: any },
		processor: types.Processor<T>
	): pubTypes.Absorb<T, U>
		local self = setmetatable({
			meta = "Absorb",
			static = false,
			_processor = processor,
			_toAbsorb = toAbsorb,
			_cases = cases,
		}, meta)
		local myGraph = graph.create(self)
		self._graph = myGraph
		self._inject = makeInjector(myGraph)

		toAbsorb._graph.dependents[myGraph] = true

		graph.run(myGraph, true, false)
		return self :: any
	end
end
