--!strict

local graph = require("../Utils/graph")
local pubTypes = require("../pubTypes")
local types = require("../types")

--[=[
	@class Hold

	An object responsible for storing singuler values.

	## API Guide
	To create a Hold:
	```lua
		local Health = Hold(100, function(old, new, isDestroying)
			return true
		end)
	```

	## Dependency-Dependent Aware Objects

	### Why?
	As in every stateful program, our app is always managed by some internal variables that vary
	in what datatypes they store, and their numbers.
]=]
local class = {}
local meta = { __index = class }


--[=[
	@within Hold

	Attempts to write to the Hold object. This operation will succeed if:
	1. The definied Processor returns true
	2. The Hold is writable, and you didnt set `isWritable(..., false)` on the object

	```lua
		local name = Hold("Sinlernick", Vinum.alwaysTrue)
		name:set("Adam")
	```

	@param value T 
]=]
function class:set(value)
	if not self._writable then
		return
	end

	if not self._processor(self._value, value, false) then
		return
	end

	self._value = value

	graph.run(self._graph, false, true)
end

--[=[
	@within Hold

	Returns the current value the `Hold` is containing.

	```lua
		local name = Hold("Sinlernick", Vinum.alwaysTrue)
		print(name:get()) -- "Sinlernick" is printed
	```

	@return T
]=]
function class:get()
	return self._value
end

return function<T>(newValue: T, processor: types.Processor<T>): pubTypes.Hold<T>
	local self = setmetatable({
		_value = newValue,
		meta = "Hold",
		static = true,
		_processor = processor,
		_writable = true,
	}, meta)

	self._graph = graph.create(self)

	return self :: any
end
