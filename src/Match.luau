local graph = require(script.Parent.utils.graph)
local useState = require(script.Parent.utils.useState)
local useStateKey = require(script.Parent.utils.useKeyState)
local Symbols = require(script.Parent.utils.Symbols)

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
	local chosenArm = cases[self._inputState:get()] or cases["default"]

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

--[=[
	Returns the current value.

	```lua
	local Root = Hold(100, Vinum.AlwaysTrue)
	local Dependency = Hold(200, Vinum.AlwaysTrue)
	local MatchState = Match(Root, {
		[100] = function(useState, useKeyState)
			return string.format("My level is %s", useState(Dependency))
		end,
		["default"] = function(_, _)
			return "not found"
		end
	}, Vinum.AlwaysTrue)


	print(MatchState:get()) -- My level is 200
	Root:set(4)
	print(MatchState:get()) -- not found
	```

	@return any -- The cached value
	@within Match
]=]
function class:get()
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
