--!strict
local graph = require("../Utils/graph")
local pubTypes = require("../pubTypes")
local types = require("../types")
local makeInjector = require("../Utils/makeInjector")
local asyncInjector = require("../Utils/asyncInjector")
local staticInjector = require("../Utils/staticInjector")
local becomeInjector = require("../Utils/becomeInjector")
local alwaysTrue = require("../Utils/alwaysTrue")

local class = {}
local meta = { __index = class }

--graph utils
local createGraph = graph.create
local runGraph = graph.run

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
		addAsync: (types.AsyncOperation<any>) -> types.AsyncOperation<any>,
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
	local myGraph = createGraph(self)
	self._graph = myGraph
	self._inject = makeInjector(myGraph)
	self._asyncInject = asyncInjector(myGraph)
	self._staticInject = staticInjector(myGraph)
	self._becomeInject = becomeInjector(myGraph)

	runGraph(myGraph, true, false)
	self._processor = processor
	return self
end
