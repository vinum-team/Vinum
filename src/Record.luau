local graph = require(script.Parent.utils.graph)
local read = require(script.Parent.utils.read)

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
}

function class:_update()
	self._value = read(self._owner)
	return self._isSynced
end

function class:_setValue(newValue: any)
	if self._isWritable == false then
		return
	end

	self._value = newValue
	self._graph:updateDependents()
end

function class:_getValue()
	return self._value
end

local function Record<T>(state, isSynced)
	local self = setmetatable({
		_isSelfContained = true,
		_isStaticDependency = true,
		_owner = state,
		_value = read(state),
		_isSynced = read(isSynced),
		_graph = {},
		_isWritable = false,
	}, meta)

	self._graph = graph(self)

	return self :: Record<T>
end

return Record
