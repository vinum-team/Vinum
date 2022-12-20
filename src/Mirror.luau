local graph = require(script.Parent.utils.graph)
local Symbols = require(script.Parent.utils.Symbols)

--[=[
	@class Mirror

	```lua
	function Mirror<T, U>(
		inputState: { _value: T, [any]: any }, -- The object that Mirror will base off objects
		cases: { [T | "default"]: { _value: U, [any]: any } } -- A map of objects being linked to a specific value.
	)
	```

	Constructs a Mirror object that will mirror a specific object's value based on the given state object.
]=]
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

	self._value = chosenArm._value
	return self._value
end

--[=[
	Returns the current value.

	```lua
	local root = Hold(100, Vinum.AlwaysTrue)
	local mirrorObject = Mirror(root, {
		[100] = Hold("I am level 100", Vinum.AlwaysTrue),
		[200] = Hold("I am level 200", Vinum.AlwaysTrue),
		["default"] = Hold("My level isn't listed here", function() 
			return false 
		end)
	})

	print(mirrorObject:get()) -- "I am level 100"
	root:set(200)
	print(mirrorObject:get()) -- "I am level 200"
	```

	:::danger
	Omitting the "default" key can cause errors, since if Mirror doesn't find an object that its case key isn't
	equal to the new value of inputState, it will default to `default`- expecting it to exist.
	:::
	@return any -- The cached value
	@within Mirror
]=]
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
