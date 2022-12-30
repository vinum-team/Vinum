local graph = require(script.Parent.utils.graph)

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
local class = { type = "state", kind = "wrap" }
local meta = { __index = class }
local Symbols = require(script.Parent.utils.Symbols)

--[=[
	Disconncts the connection that Wrap uses to automatically update your wrapped object.
	
	```lua
	local wrapState1, wrapState2 = Wrap(AnySignal, 2, 100, 200)

	wrapState1:disconnect()
	wraoState2:disconnect()
	```
	@within Wrap
]=]
function class:disconnect()
	self._disconnected = true
	self._internalConnection:Disconnect()
end

function class:_getValue()
	return self._value
end

function class:_setValue(newValue: any)
	self._value = newValue
	self._graph:updateDependents()
end

local function Wrap(
	Signal: RBXScriptSignal | {
		Connect: (fn: (...any) -> ()) -> (any),
	},
	numOfArguments: number,
	...: any
)
	local states = table.create(numOfArguments)

	for i = 1, numOfArguments do
		local self = setmetatable({
			_disconnected = false,
			_isSelfContained = true,
			_isStaticDependency = true,
			_value = select(i, ...) or Symbols.None,
			_graph = {},
		}, meta)

		self._graph = graph(self)

		self._internalConnection = (Signal :: any):Connect(function(...)
			self._value = select(i, ...)
			self._graph:update()
		end)

		table.insert(states, self)
	end

	return table.unpack(states)
end

return Wrap
