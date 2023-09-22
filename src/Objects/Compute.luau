--!strict
local graph = require(script.Parent.Parent.Utils.graph)
local pubTypes = require(script.Parent.Parent.pubTypes)
local types = require(script.Parent.Parent.types)
local makeInjector = require(script.Parent.Parent.Utils.makeInjector)
local asyncInjector = require(script.Parent.Parent.Utils.asyncInjector)
local staticInjector = require(script.Parent.Parent.Utils.staticInjector)
local becomeInjector = require(script.Parent.Parent.Utils.becomeInjector)
local alwaysTrue = require(script.Parent.Parent.Utils.alwaysTrue)

local class = {}
local meta = { __index = class }

function class:set(value)
	if not self._writable then
		return
	end

	if not self._processor(self._value, value, false) then
		return
	end

	self._value = value

	graph.run(self._graph, false, true)
end
function class:_update()
	local value = self._computer(self._inject, self._asyncInject, self._staticInject, self._becomeInject)
	if not self._processor(self._value, value, false) then
		return
	end

	self._value = value
end

function class:get()
	return self._value
end

return function<T, U>(
	computer: (
		inject: pubTypes.inject<U>,
		async: (() -> ()) -> types.AsyncOperation<any>,
		staticify: (boolean) -> ()
	) -> T,
	processor: types.Processor<T>
): pubTypes.Compute<T, U>
	local self = (
		setmetatable({
			meta = "Compute",
			static = false,
			_computer = computer,
			_processor = alwaysTrue,
			_writable = false,
		}, meta) :: any
	) :: pubTypes.Compute<T, U>
	local myGraph = graph.create(self)
	self._graph = myGraph
	self._inject = makeInjector(myGraph)
	self._asyncInject = asyncInjector(myGraph)
	self._staticInject = staticInjector(myGraph)
	self._becomeInject = becomeInjector(myGraph)

	graph.run(myGraph, true, false)
	self._processor = processor
	return self
end
