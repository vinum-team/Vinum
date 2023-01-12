local graph = require(script.Parent.utils.graph)
local read = require(script.Parent.utils.read)
--[=[
	@class Wrap

	```lua
	function Wrap(
		Signal: RBXScriptSignal | {
			Connect: (fn: (...any) -> ()) -> (any),
		}, -- The signal that will be used to derive objects from
		numOfArguments: number, -- The number of arguments that Wrap will detect
		...: any -- The default values for the objects that will be created by Wrap.
	)
	```

	Constructs a Wrap object that wraps a Signal. The number of arguments is equal to the number of objects that will be created
	that captures a specific argument in the event. The `...` is for setting initial values- the order of the values in this one should map the 
	numOfArguments parameter.
]=]
local class = { type = "state", kind = "wrap", behavior = "center" }
local meta = { __index = class }

function class:_update()
	local event = read(self._signal)

	if self._currentEvent ~= event then
		if self._currentEvent then
			self._currentConnection:Disconnect()
		end

		self._currentConnection = event:Connect(function(...)
			for index in self._values do
				self._values[index] = select(index, ...)
			end

			for index, value in table.pack(self._handler(...)) do
				self._values[index] = value
			end

			self._graphs[1]:update()
		end)

		self._currentEvent = event
	end
	return true
end

function class:_getValue(index)
	return self._values[index]
end

function class:_setValue(newValue: any)
	if self._isWritable == false then
		return
	end

	self._value = newValue
	self._graph:updateDependents()
end

local function Wrap(Signal: RBXScriptSignal | any, defaultValues: { any }, handler: () -> ())
	local self = setmetatable({
		_signal = Signal,
		_isStaticDependency = true,
		_values = defaultValues,
		_graphs = {},
		_isWritable = false,
		_handler = handler,
	}, meta)

	local mainGraph
	for index in defaultValues do
		local graphObj
		if index == 1 then
			graphObj = graph(self)

			if type(Signal) == "table" and Signal.behavior ~= "center" and Signal.tyoe == "state" then
				Signal._graph._dependentSet[graphObj] = true
				graphObj._dependencySet[Signal._graph] = true
			end

			mainGraph = graphObj
		else
			graphObj = graph()
			mainGraph._dependentSet[graphObj] = true
			graphObj._dependencySet[mainGraph] = true
		end
		table.insert(self._graphs, graphObj)
	end

	mainGraph:update()

	return self
end

return Wrap
