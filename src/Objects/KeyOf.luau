--!strict
local graph = require(script.Parent.Parent.Utils.graph)
local pubTypes = require(script.Parent.Parent.pubTypes)
local types = require(script.Parent.Parent.types)

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
	local obj = self._obj
	local objGraph = obj._graph
	local myGraph = self._graph

	obj._value[self._key] = value
	objGraph.dependents[myGraph] = nil
	runGraph(objGraph, false, false)
	objGraph.dependents[myGraph] = true
	runGraph(myGraph, false, false)
end

function class:_update()
	local value = self._obj._value[self._key]
	if not self._processor(self._value, value, false) then
		return
	end

	self._value = value
end

function class:get()
	return self._value
end

return function<T>(obj: types.StateObj<any, any>, key: T, processor: types.Processor<T>): pubTypes.KeyOf<any, T>
	local self = (
		setmetatable({
			_value = obj._value[key],
			_key = key,
			meta = "KeyOf",
			static = true,
			_obj = obj,
			_processor = processor,
			_writable = true,
		}, meta) :: any
	) :: pubTypes.KeyOf<any, T>
	local myGraph = createGraph(self)
	local objGraph = obj._graph
	self._graph = myGraph

	objGraph.dependents[myGraph] = true
	return self
end
