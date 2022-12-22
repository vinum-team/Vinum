local graph = require(script.Parent.utils.graph)

--[=[
	@class Hold

	```lua
	function Hold<T>(
		initialValue: T, -- The value that will be stored initially.
		updateProcessor: ( -- The function that will be used to determine whether to pass updates or not.
			oldValue, 
			newValue
		) -> (boolean)
	)
	```

	Constructs a new Hold Object, which is used to store singular values. 

	:::caution
	Passing a nil for `initialValue` is considered unsafe and can cause unintended behavior.
	:::
]=]
local class = { type = "state", kind = "hold" }
local meta = { __index = class }

export type Hold<T> = {
	type: "state",
	kind: "hold",

	_value: T,
	_updateProcessor: (oldValue: T, newValue: T) -> (boolean),
	_graph: typeof(graph()),
	get: (self: Hold<T>) -> (T),
	set: (self: Hold<T>, newValue: T) -> (),
}

--[=[
	Returns the current value from the cache
	
	```lua
	local holdState = Hold(100, Vinum.AlwaysTrue)

	print(holdState:get())
	```
	@within Hold
	@return any -- The cached value
]=]
function class:get()
	return self._value
end

--[=[
	Sets the new value of this Hold object.

	```lua
	local holdState = Hold(100, Vinum.AlwaysTrue)

	holdState:set(40)
	```
	@param newValue any -- The new value you want this object to contain
	@within Hold
]=]

function class:set(newValue)
	local shouldUpdate = self._updateProcessor(self._value, newValue)

	if shouldUpdate then
		self._value = newValue

		self._graph:update(newValue)
	end
end

local function Hold<T>(ogValue: T, updateProcessor: (T, T) -> (boolean))
	local self = setmetatable({
		_isSelfContained = true,
		_value = ogValue,
		_updateProcessor = updateProcessor,
		_graph = {},
	}, meta)

	self._graph = graph(self)

	return self :: Hold<T>
end

return Hold
