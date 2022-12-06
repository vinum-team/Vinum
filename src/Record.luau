local graph = require(script.Parent.utils.graph)
local class = { type = "state", kind = "record" }
local meta = { __index = class }

export type Record<T> = {
	_isSelfContained: true,
	_isStaticDependency: true,
	_owner: { _value: T, [any]: any },
	_value: T,
	_isSynced: boolean,
	_graph: typeof(graph()),

	_update: (T) -> (T),
	get: (self: Record<T>) -> (T),
	sync: () -> (),
	desync: () -> (),
}

function class:_update(newValue)
	self._value = newValue
	return newValue
end

function class:get()
	return self._value
end

function class:desync()
	local ownerGraph = self._owner
	local selfGraph = self._graph
	self._isSynced = false

	selfGraph._dependencySet[ownerGraph] = false
	ownerGraph._dependentSet[self._graph] = false
end

function class:sync()
	local ownerGraph = self._owner
	local selfGraph = self._graph
	self._isSynced = true

	selfGraph._dependencySet[ownerGraph] = true
	ownerGraph._dependentSet[self._graph] = true
end

local function Record<T>(state, isInitiallySynced: boolean)
	local self = setmetatable({
		_isSelfContained = true,
		_isStaticDependency = true,
		_owner = state,
		_value = state:get(),
		_isSynced = isInitiallySynced or false,
		_graph = {},
	}, meta)

	self._graph = graph(self)

	local stateGraph = state._graph
	local selfGraph = self._graph
	local isSynced = self._isSynced

	selfGraph._dependencySet[stateGraph] = isSynced
	stateGraph._dependentSet[selfGraph] = isSynced
	return self :: Record<T>
end

return Record
