local graph = require(script.Parent.utils.graph)
local Symbols = require(script.Parent.utils.Symbols)

local class = { type = "state", kind = "mirror" }
local meta = { __index = class }

function class:_update()
	local cases = self._cases
	local chosenArm = cases[self._inputState:get()] or cases["default"]
	local currentCaseDependency = self._currentCaseDependency

	if currentCaseDependency ~= chosenArm then
		local myGraph = self._graph

		if currentCaseDependency then
			local currenGraph = currentCaseDependency._graph
			currenGraph._dependentSet[myGraph] = nil
			myGraph._dependencySet[currenGraph] = nil
		end

		local chosenGraph = chosenArm._graph
		chosenGraph._dependentSet[myGraph] = true
		myGraph._dependencySet[chosenGraph] = true

		self._currentCaseDependency = chosenArm
	end

	self._value = chosenArm:get()
	return self._value
end

function class:get()
	return self._value
end

return function(inputState, cases: { [any]: any })
	local self = setmetatable({
		_isSelfContained = true,
		_isStaticDependency = false,
		_cases = cases,
		_value = Symbols.None,
		_inputState = inputState,
		_currentCaseDependency = false,
	}, meta)

	self._graph = graph(self)
	local myGraph = self._graph

	inputState._graph._dependentSet[myGraph] = true

	myGraph:update()
	return self
end
