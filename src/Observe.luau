local graph = require(script.Parent.utils.graph)
local spawner = require(script.Parent.utils.spawner)

--[=[
	@class Observe

	```lua
	function Observe(
		state, 
		updateProcessor: (newValue: any) -> (boolean) -- The function that Observe will use to determine whether to let updates pass or not
	)
	```

	Constructs a new Observe object, which is used for listening to changes on a state object.
]=]
local class = { type = "state", kind = "observe" }
local meta = { __index = class }

function class:_update(newValue)
	if not self._updateProcessor(newValue) then
		return
	end

	for connection in self._connections do
		spawner(connection, newValue)
	end
end

--[=[
	Connects a function that will run whenever the observed is changed. Returns a function that disconnects the connection.

	```lua
	local health = Hold(100, Vinum.AlwaysTrue)

	local healthObserver = Observe(health, Vinum.AlwaysTrue)

	healthObserver:onChange(function(newValue)
		print(newValue)
	end)
	```
	@return () -> ()
	@within Observe
]=]
function class:onChange(funct: (newValue: any) -> ())
	self._connections[funct] = true

	return function()
		self._connections[funct] = nil
	end
end

--[=[
	Runs the function and then connect it, which makes it run every time the observed state is changed. Like onChange, it returns a 
	function that will disconnect the connection. 

	Instead of:
	```lua
	local health = Hold(100, Vinum.AlwaysTrue)

	local healthObserver = Observe(health, Vinum.AlwaysTrue)

	Humanoid.Health = health:get()
	healthObserver:onChange(function(newValue)
		Humanoid.Health = newValue
	end)
	```

	It is:
	```lua
	local health = Hold(100, Vinum.AlwaysTrue)

	local healthObserver = Observe(health, Vinum.AlwaysTrue)

	healthObserver:onBind(function(newValue) 
		Humanoid.Health = newValue
	end)
	```

	@return () -> ()
	@within Observe
]=]
function class:onBind(funct: (newValue: any) -> ())
	funct(self._state:get())

	return self:onChange(funct)
end

return function(state, updateProcessor: (newValue: any) -> (boolean))
	local self = setmetatable({
		_isSelfContained = true,
		_isStaticDependency = true,
		_updateProcessor = updateProcessor,
		_connections = {},
		_graph = {},
		_state = state
	}, meta)

	self._graph = graph(self)

	self._graph._dependencySet[state._graph] = true
	state._graph._dependentSet[self._graph] = true
	return self
end
