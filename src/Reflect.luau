local graph = require(script.Parent.utils.graph)
local read = require(script.Parent.utils.read)
--[=[
	@class Reflect

	```lua
	function Reflect(state: anyState)
	```

	Constructs a Reflect object, which is used to created a mirrored version of the given state object. Useful for creating 
	immutable copies of a state object without any performance loses.
]=]
local class = { type = "state", kind = "reflect" }
local meta = { __index = class }

export type Reflect<T> = {
	type: "state",
	kind: "reflect",
	_owner: { _value: T, [any]: any },
	_graph: typeof(graph()),
	get: (self: Reflect<T>) -> (T),
}

--[=[
	Returns the current value that is stored in Reflect's Reflected object. Keep in mind that the returned value is the same
	as the reflected's value.

	```lua
	local holdState = Hold({23}, Vinum.AlwaysTrue)
	local reflectState = Reflect(holdState)

	print(holdState:get() == reflectState:get()) -- true
	```
	@return any -- The value that `state` has.
	@within Reflect
]=]

function class:_getValue()
	return read(self._owner)
end

local function Reflect<T>(state: { _value: T, [any]: any })
	local self = setmetatable({
		_isSelfContained = true,
		_owner = state,
		_graph = state._graph,
	}, meta)
	return self :: Reflect<T>
end

return Reflect
