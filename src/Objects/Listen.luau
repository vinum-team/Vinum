--!strict
local graph = require(script.Parent.Parent.Utils.graph)
local pubTypes = require(script.Parent.Parent.pubTypes)
local types = require(script.Parent.Parent.types)

local class = {}
local meta = { __index = class }

-- graph
local createGraph = graph.create

function class:set(value)
	if not self._writable then
		return
	end

	if not self._processor(self._value, value, false) then
		return
	end

	self._value = value

	graph.run(self._graph, false)
end

function class:get()
	return self._value
end

function class:_update()
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

	if self._canYield then
		for fn in self._connections do
			task.spawn(fn, old, new)
		end
	else
		for fn in self._connections do
			fn(old, new)
		end
	end
end

function class:Connect(fn)
	self._connections[fn] = true

	return function()
		self._connections[fn] = nil
	end
end

function class:Bind(fn)
	local value = self._value
	fn(value.old, value.new)

	return self:Connect(fn)
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

	local myGraph = createGraph(self)
	self._graph = myGraph

	local dependencyGraph = dependency._graph
	dependencyGraph.dependents[myGraph] = true

	return self :: any
end
