local graph = require(script.Parent.utils.graph)
local read = require(script.Parent.utils.read)
local write = require(script.Parent.utils.write)
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

function class:_getValue()
	return read(self._owner)
end

function class:_setValue(newValue)
	if self._isWritable == false then
		return
	end

	return write(self._owner, newValue)
end

local function Reflect<T>(state: { _value: T, [any]: any })
	local self = setmetatable({
		_isSelfContained = true,
		_owner = state,
		_graph = state._graph,
		_isWritable = false
	}, meta)
	return self :: Reflect<T>
end

return Reflect
