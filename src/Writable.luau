local graph = require(script.Parent.utils.graph)

--[=[
	@class Writable

	```lua
	function Writable(state: anyState)
	```

	Constructs a Writable object, which is used for writing to already immutable state objects.
]=]
local class = { type = "state", kind = "writable" }
local meta = { __index = class }

export type Writable<T> = {
	type: "state",
	kind: "writable",
	_owner: { _value: T, [any]: any },
	_graph: typeof(graph()),
	get: (self: Writable<T>) -> (T),
	set: (self: Writable<T>, newValue: T) -> (T),
}
--[=[
	Returns the current value that is stored in Writable's owner object. Keep in mind that the returned value is the same
	as the owner's value.

	```lua
	local holdState = Hold({23}, Vinum.AlwaysTrue)
	local WritableState = Writable(holdState)

	print(holdState:get() == WritableState:get()) -- true
	```
	@return any -- The value that `state` has.
	@within Writable
]=]
function class:get()
	return self._owner:get()
end

--[=[
	Sets to the current value, and launches an update to all of its owner dependents.

	```lua
	local holdState = Hold({23}, Vinum.AlwaysTrue)
	local WritableState = Writable(holdState)

	WritableState:set(400)
	print(holdState:get()) -- 400
	```
	@param newValue any
	@within Writable
]=]
function class:set(newValue)
	self._owner._value = newValue

	self._graph:update(newValue)
end

local function Writable<T>(state: { _value: T, [any]: any })
	local self = setmetatable({
		_isSelfContained = true,
		_owner = state,
		_graph = state._graph,
	}, meta)

	return self
end

return Writable
