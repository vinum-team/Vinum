local graph = require(script.Parent.utils.graph)

--[=[
	@class Record

	```lua
	function Record(state: anyState, isInitiallySynced: boolean)
	```

	Constructs a record which acts as an actual copy of `state`, unlike Reflect. 
]=]
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

function class:_update()
	self._value = self._owner:get()
	return self._value
end

--[=[
	Returns the current saved value in the Record

	:::caution
	If the Record isn't synced, the value that will be returned by this method might not
	be equal to the recorded object's current value.
	:::

	```lua
	local holdState = Hold(100, Vinum.AlwaysTrue)
	local RecordState = Record(holdState, true)

	holdState:set(40)
	print(holdState:get() == RecordState:get()) -- true
	```
	@return any -- The value in the cache
	@within Record
]=]
function class:get()
	return self._value
end

--[=[
	Desyncs the Record object, which means any future updates will not be applied until `:sync` is called.

	```lua
	local holdState = Hold(100, Vinum.AlwaysTrue)
	local RecordState = Record(holdState, true)

	RecordState:desync()
	holdState:set(40)
	print(holdState:get() == RecordState:get()) -- false
	```
	@within Record
]=]
function class:desync()
	if self._isSynced == false then
		return 
	end

	local ownerGraph = self._owner._graph
	local selfGraph = self._graph
	self._isSynced = false

	selfGraph._dependencySet[ownerGraph] = false
	ownerGraph._dependentSet[selfGraph] = false
end
--[=[
	Syncs the Record object, which means the current value is synced to the Recorded object, and an update will be performed, plus, all 
	future updates will be listened to from now on.

	@within Record
]=]
function class:sync()
	if self._isSynced == true then
		return 
	end

	local ownerGraph = self._owner._graph
	local selfGraph = self._graph
	self._isSynced = true

	selfGraph._dependencySet[ownerGraph] = true
	ownerGraph._dependentSet[selfGraph] = true

	if self._owner:get() ~= self._value then
		selfGraph:update()
	end
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
