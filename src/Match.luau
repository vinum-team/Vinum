local graph = require(script.Parent.utils.graph)
local useState = require(script.Parent.utils.useState)
local useStateKey = require(script.Parent.utils.useKeyState)
local Symbols = require(script.Parent.utils.Symbols)

local class = {}
local meta = { __index = class }

function class:_update()
	local cases = self._cases
	local chosenArm = cases[self._inputState._value] or cases["default"]

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

function class:get()
	return self._value
end

return function(
	inputState,
	cases: { [any]: (useState: (dependency: any) -> (any), useKey: (dependency: any) -> (any)) -> () },
	updateProcessor: (oldValue: any, newValue: any) -> (boolean)
)
	local self = setmetatable({
		type = "state",
		kind = "match",

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
