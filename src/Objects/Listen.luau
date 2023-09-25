--!strict
local graph = require(script.Parent.Parent.Internal.graph)
local setmetatable = require(script.Parent.Parent.Internal.setmetatable)
local pubTypes = require(script.Parent.Parent.pubTypes)
local types = require(script.Parent.Parent.types)

local class = {}
local meta = { __index = class }

local task = (task or require("@lune/task")) :: any

type Listen = pubTypes.Listen<any>

function class.get(self: Listen)
	return self._value
end

function class._update(self: Listen)
	local value = self._dependency:get()
	local valueSet = self._value

	if valueSet.new then
		valueSet.old = valueSet.new
		valueSet.new = value
	else
		valueSet.new = value
	end
	if not self._processor(valueSet.old, value, false) then
		return
	end

	local old = valueSet.old
	local new = valueSet.new

	for fn in self._connections do
		task.spawn(fn, old, new)
	end
end

function class:connect(fn)
	self._connections[fn] = true

	return function()
		self._connections[fn] = nil
	end
end

function class:bind(fn)
	local value = self._value
	fn(value.old, value.new)

	return self:connect(fn)
end

return function<T>(dependency: types.StateObj<any, T>, processor: types.Processor<T>): pubTypes.Listen<{ old: T, new: T }>
	local self = setmetatable({
		_value = { old = dependency._value, new = nil },
		meta = "Listen",
		static = true,
		_processor = processor,
		_dependency = dependency,
		_connections = {},
		_writable = false,
		_canYield = true,
	}, meta)

	local myGraph = graph.create(self)
	self._graph = myGraph

	local dependencyGraph = dependency._graph
	dependencyGraph.dependents[myGraph] = true

	return self :: any
end
