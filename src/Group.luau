local graph = require(script.Parent.utils.graph)
local spawner = require(script.Parent.utils.spawner)
local Symbols = require(script.Parent.utils.Symbols)

--[=[
	@class Group

	```lua
	function Group(
		setProcessor: ( -- The function that Group use to determine whether to let set calls perform an update or not.
			keyName: string,
			oldKeyValue: unknown,
			keyValue: unknown
		) -> (boolean)
	)
	```

	Constructs a Group object, which is used for storing centralized state.
]=]
local class = { type = "state", kind = "group" }
local meta = { __index = class }

--[=[
	@type GroupSelfContained {name: string, _graph: graph, get: (self) -> (any)}

	@within Group
]=]

local selfContainedClass = { __index = {
	get = function(self)
		return self._graph._owner._values[self.name]
	end,
} }

--[=[
	A method to set a key's value to a new one. Fires the `setProcessor` that was definied on Groups' construction.

	```lua
	local centerState = Group(Vinum.AlwaysTrue)

	centerState:setKey("health", 100)
	```
	@param keyName string -- The key that the new value will be set at
	@param keyValue any -- The value that will be set.

	@within Group
]=]
function class:setKey(keyName: string, keyValue: any)
	local values = self._values
	local oldValue = values[keyName] or Symbols.None
	if self._setProcessor(keyName, oldValue, keyValue) then
		if values[keyName] then
			values[keyName] = keyValue
			self._graphs[keyName]:update(keyValue)
		else
			values[keyName] = keyValue
			self._graphs[keyName] = graph(self)
		end

		for connection in self._connections do
			spawner(connection, keyName, oldValue, keyValue)
		end
	end
end

--[=[
	Returns the current value that is saved at the provided key.

	```lua
	local centerState = Group(Vinum.AlwaysTrue)
	centerState:setKey("health", 100)

	print(centerState:getKey("health"))
	```
	@param keyName string? -- The key that Group will use to locate the value. Can be nil
	@return keyValue any
	@within Group
]=]
function class:getKey(keyName: string)
	return self._values[keyName]
end

--[=[
	Returns an object that acts as a self-contained object. Useful for integration with other objects.

	```lua
	local centerState = Group(Vinum.AlwaysTrue)
	centerState:setKey("health", 100)

	local health = centerState:asState("health")

	print(health:get())
	```
	@param KeyName string -- The key that the returned object will emulate.
	@return object GroupSelfContained
	@within Group
]=]
function class:asState(KeyName: string)
	return setmetatable({ name = KeyName, _graph = self._graphs[KeyName] }, selfContainedClass)
end
--[=[
	Connects a function that will fire once a key changes.

	```lua
	local centerState = Group(Vinum.AlwaysTrue)
	centerState:setKey("health", 100)

	centerState:onChange(function(keyName, oldValue, keyValue)
		print(keyName, oldValue, keyValue)
	end)

	centerState:setKey("health", 50)
	```
	@param fn (keyName: string, oldValue: unknown, keyValue: unknown) -> ()
	@within Group
]=]
function class:onChange(fn)
	self._connections[fn] = true

	return function()
		self._connections[fn] = nil
	end
end

local function Group(setProcessor: (keyName: string, oldKeyValue: unknown, keyValue: unknown) -> (boolean))
	local self = setmetatable({
		_isStaticDependency = false,
		_isSelfContained = false,
		_setProcessor = setProcessor,
		_values = {},
		_graphs = {},
		_connections = {},
	}, meta)
	return self
end

return Group
