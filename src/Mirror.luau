local graph = require(script.Parent.utils.graph)
local Symbols = require(script.Parent.utils.Symbols)

local class = { type = "state", kind = "mirror" }
local meta = { __index = class }

export type Mirror<T, U> = {
	type: "state",
	kind: "mirror",
	_isSelfContained: true,
	_isStaticDependency: true,
	_cases: { any },
	_value: typeof(Symbols.None) | T,
	_inputState: any,
	_currentCaseDependency: any,

	_update: () -> (U?),
	get: () -> (U),
}

function class:_update()
	local cases = self._cases
	local chosenArm = cases[self._inputState._value] or cases["default"]
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

	self._value = chosenArm._value
	return self._value
end

function class:get()
	return self._value
end

local function Mirror<T, U>(inputState: { _value: T, [any]: any }, cases: { [T | "default"]: { _value: U, [any]: any } })
	local self = setmetatable({
		_isSelfContained = true,
		_isStaticDependency = true,
		_cases = cases,
		_value = Symbols.None,
		_inputState = inputState,
		_currentCaseDependency = false,
	}, meta)

	self._graph = graph(self)
	local myGraph = self._graph

	inputState._graph._dependentSet[myGraph] = true

	myGraph:update()
	return self :: Mirror<T, U>
end
return Mirror
