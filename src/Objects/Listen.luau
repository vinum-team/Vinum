--!strict
local graph = require("../Utils/graph")
local pubTypes = require("../pubTypes")
local types = require("../types")

--FIXME: This fix should be replaced.
local task = (task or require("@lune/task")) :: any

--[=[
	@class Listen

	An object responsible for Listening to State object updates.
]=]
local class = {}
local meta = { __index = class }

-- graph
local createGraph = graph.create

--[=[
	@within Listen

	Attempts to write to the Listen object. This operation will succeed if:
	1. The definied Processor returns true
	2. The Listen is writable, and you didnt set `isWritable(..., false)` on the object
	3. The new data is `{old: T, new: T}`, and `T` is the same as the type of the recorded type. 

	:::warning
	Due to vinum's intentional design policy for non runtime type checking, you are expected
	to use Luau's typechecker engine. As such, any violation of the third rule can and would raise an internal error in some 
	cases.
	:::

	```lua
		local someListener = ...

		Listen:set({old = false, new: true})
	```
	@param value {old: T, new: T}
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
	@within Listen

	Returns the current value the `Listen` is containing.

	```lua
		local someListener = ...

		print(someListener:get()) -- {old = true, new = false}
	```

	@return {old: T, new: T}
]=]
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
			--TODO: Implement a runtime-agnostic scheduler instead of
			--using Roblox's s task library, which could apply some optimizations such as thread reusing?
			task.spawn(fn, old, new)
		end
	else
		for fn in self._connections do
			fn(old, new)
		end
	end
end

--[=[
	@within Listen

	The method for registering functions as connections. Returns a disconnector.

	```lua
		local someListener = ...

		someListener:connect(function(old, new)
			print(`old value: {old}, new version: {new}`)
		end)
	```
	@param fn (old: T, new: T) -> ()
	@return () -> () -- The disconnector function
]=]
function class:connect(fn)
	self._connections[fn] = true

	return function()
		self._connections[fn] = nil
	end
end

--[=[
	@within Listen

	The method for registering functions as bindings. Similar to `:connect`, but instead of just registering connections, it will also
	run the given function.
		
	:::danger
	Due to the internal workings of Listen, when using `:bind` with a newly created listener that has yet to observe a new update, the `new` 
	argument will be nil.
	:::

	```lua
		local someListener = ...

		someListener:bind(function(old, new)
			print(`old value: {old}, new version: {new}`) -- it could be "old value: oldValue, new version: nil"!
		end
	```
	@param fn (old: T, new: T) -> ()
	@return () -> () -- The disconnector function
]=]
function class:bind(fn)
	local value = self._value
	fn(value.old, value.new)

	return self:connect(fn)
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
