--!strict
local graph = require(script.Parent.Parent.Internal.graph)
local setmetatable = require(script.Parent.Parent.Internal.setmetatable)
local pubTypes = require(script.Parent.Parent.pubTypes)
local types = require(script.Parent.Parent.types)
local makeInjector = require(script.Parent.Parent.Internal.makeInjector)
local asyncInjector = require(script.Parent.Parent.Internal.asyncInjector)
local staticInjector = require(script.Parent.Parent.Internal.staticInjector)
local becomeInjector = require(script.Parent.Parent.Internal.becomeInjector)
local alwaysTrue = require(script.Parent.Parent.Utils.alwaysTrue)

local class = {}
local meta = { __index = class }

type Compute = pubTypes.Compute<any>

function class._update(self: Compute)
	local value = self._computer(self._inject, self._asyncInject, self._staticInject, self._becomeInject)
	if not self._processor(self._value, value, false) then
		return
	end

	self._value = value
end

function class.get(self: Compute)
	return self._value
end

return function<T>(
	computer: (
		inject: pubTypes.inject,
		async: (() -> ()) -> types.AsyncOperation<any>,
		staticify: (boolean) -> ()
	) -> T,
	processor: types.Processor<T>
): pubTypes.Compute<T>
	local self = setmetatable({
		meta = "Compute",
		static = false,
		_computer = computer,
		_processor = alwaysTrue,
		_writable = false,
	}, meta) :: Compute

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
