local graph = require(script.Parent.utils.graph)
local class = {}
local meta = { __index = class }

local freeThread

local function functionPasser(fn, ...)
	fn(...)
end

local function yielder()
	while true do
		functionPasser(coroutine.yield())
	end
end

local function SpawnWithReuse(fn, ...)
	if not freeThread then
		freeThread = coroutine.create(yielder)
		coroutine.resume(freeThread)
	end
	local acquiredThread = freeThread
	freeThread = nil
	task.spawn(acquiredThread, fn, ...)
	freeThread = acquiredThread
end

function class:_update(newValue)
	if not self._updateProcessor(newValue) then
		return
	end

	for connection in self._connections do
		SpawnWithReuse(connection, newValue)
	end
end

function class:onChange(funct)
	self._connections[funct] = true

	return function()
		self._connections[funct] = nil
	end
end

return function(state, updateProcessor)
	local self = setmetatable({
		type = "state",
		kind = "observe",

		_updateProcessor = updateProcessor,
		_connections = {},
		_graph = {}
	}, meta)

	self._graph = graph(self)

	self._graph._dependencySet[state] = true
	state._graph._dependentSet[self] = true
	return self
end
