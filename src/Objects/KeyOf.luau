--!strict
local graph = require(script.Parent.Parent.Internal.graph)
local setmetatable = require(script.Parent.Parent.Internal.setmetatable)
local pubTypes = require(script.Parent.Parent.pubTypes)
local types = require(script.Parent.Parent.types)

local class = {}
local meta = { __index = class }

type KeyOf = pubTypes.KeyOf<any, any>

function class.set(self: KeyOf, value)
	if not self._processor(self._value, value, false) then
		return
	end

	self._value = value
	local obj = self._obj
	local objGraph = obj._graph
	local myGraph = self._graph

	obj._value[self._key] = value
	objGraph.dependents[myGraph] = nil
	graph.run(objGraph, false, false)
	objGraph.dependents[myGraph] = true
	graph.run(myGraph, false, false)
end

function class._update(self: KeyOf)
	local value = self._obj._value[self._key]
	if not self._processor(self._value, value, false) then
		return
	end

	self._value = value
end

function class.get(self: KeyOf)
	return self._value
end

return function<T>(obj: types.StateObj<any, any>, key: T, processor: types.Processor<T>): pubTypes.KeyOf<any, T>
	local self = setmetatable({
		_value = obj._value[key],
		_key = key,
		meta = "KeyOf",
		static = true,
		_obj = obj,
		_processor = processor,
		_writable = true,
	}, meta) :: KeyOf
	local myGraph = graph.create(self)
	local objGraph = obj._graph
	self._graph = myGraph

	objGraph.dependents[myGraph] = true
	return self
end
