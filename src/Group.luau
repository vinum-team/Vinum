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

local selfContainedClass = {
	__index = {
		_getValue = function(self)
			return self._graph._owner._values[self.name]
		end,
	},
}

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

function class:_setValue(keyName, value)
	local values = self._values
	local oldValue = values[keyName] or Symbols.None
	if self._setProcessor(keyName, oldValue, value) then
		if values[keyName] then
			values[keyName] = value
			self._graphs[keyName]:update(value)
		else
			values[keyName] = value
			self._graphs[keyName] = graph(self)
		end

		for connection in self._connections do
			spawner(connection, keyName, oldValue, value)
		end
	end
end

function class:_getValue(keyName)
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

local function Group(initalState, setProcessor: (keyName: string, oldKeyValue: unknown, keyValue: unknown) -> (boolean))
	local self = setmetatable({
		_isStaticDependency = false,
		_isSelfContained = false,
		_setProcessor = setProcessor,
		_values = initalState or {},
		_graphs = {},
		_connections = {},
	}, meta)

	for key in initalState do
		self._graphs[key] = graph(self)
	end

	return self
end

return Group
