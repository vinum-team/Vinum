local graph = require(script.Parent.utils.graph)
local useState = require(script.Parent.utils.useState)
local useStateKey = require(script.Parent.utils.useKeyState)
local Symbols = require(script.Parent.utils.Symbols)
local read = require(script.Parent.utils.read)

--[=[
	@class Match

	```lua
	function(
		inputState, -- The object that Mirror will base off objects
		cases: { [any]: (useState, useKeyState) -> () }, -- A map of objects being linked to a specific value.
		updateProcessor: (oldValue: any, newValue: any) -> (boolean) -- a function that Match uses to determine whether to let updates pass or not
	)
	```
	Constructs a Match object, which is used for mirroring certain computations based on an object's value.
]=]
local class = { type = "state", kind = "match" }
local meta = { __index = class }

function class:_update()
	local cases = self._cases
	local chosenArm = cases[read(self._inputState)] or cases["default"]

	local oldValue = self._value
	self._value = Symbols.Pending
	local newArmValue = chosenArm(self._useHelper, self._useKeyHelper)

	if self._updateProcessor(oldValue, newArmValue) then
		self._value = newArmValue
		return newArmValue
	else
		self._value = oldValue
		return nil
	end
end

function class:_setValue(newValue: any)
	if not self._updateProcessor(self._value, newValue) then 
		return 
	end

	self._value = newValue
	self._graph:updateDependents()
end

function class:_getValue()
	return self._value
end

return function(
	inputState,
	cases: { [any]: (useState: (dependency: any) -> (any), useKey: (dependency: any) -> (any)) -> () },
	updateProcessor: (oldValue: any, newValue: any) -> (boolean)
)
	local self = setmetatable({
		_isSelfContained = true,
		_isStaticDependency = false,
		_cases = cases,
		_value = Symbols.None,
		_updateProcessor = updateProcessor,
		_inputState = inputState,
	}, meta)

	self._graph = graph(self)
	self._useHelper = useState(self)
	self._useKeyHelper = useStateKey(self)
	local myGraph = self._graph

	inputState._graph._dependentSet[myGraph] = true

	myGraph:update()
	return self
end
