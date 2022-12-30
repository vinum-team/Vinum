local graph = require(script.Parent.utils.graph)
local use = require(script.Parent.utils.use)
local Symbols = require(script.Parent.utils.Symbols)

--[=[
	@class Calc

	```lua
	function Calc<T>(
		calculator: (useState, useKeyState) -> (T), -- The function that Calc will use to perform calculations
		updateProcessor: (T, T) -> (boolean) -- The function that Calc will use to determine whether to let updates pass or not
	)
	```
	Constructs a new Calc object, which is used for deriving values from dependencies.
]=]
local class = { type = "state", kind = "calc" }
local meta = { __index = class }

type Tuse = typeof(use())
export type Calc<T> = {
	type: "state",
	kind: "calc",

	_isStaticDependency: false,
	_isSelfContained: true,
	_calculator: (use: Tuse) -> (T),
	_value: { type: "Symbol", value: "None" } | T,
	_updateProcessor: (oldValue: T, newValue: T) -> (boolean),
	_graph: typeof(graph()),
	_update: (self: Calc<T>) -> (T | nil),
	get: (self: Calc<T>) -> (T),
}

function class:_update()
	local oldValue = self._value
	self._value = Symbols.Pending
	local newValue = self._calculator(self._use)

	if self._updateProcessor(oldValue, newValue) then
		self._value = newValue
		return self._value
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

local function Calc<T>(
	calculator: (useState: (dependency: any) -> (T), useKey: (dependency: any) -> (T)) -> (),
	updateProcessor: (oldValue: T, newValue: T) -> (boolean)
)
	local self = setmetatable({
		_isStaticDependency = false,
		_isSelfContained = true,
		_calculator = calculator,
		_value = Symbols.None :: { type: string, value: string } | any,
		_updateProcessor = updateProcessor,
		_graph = {} :: typeof(graph()),
		_onInit = true,
	}, meta)

	self._graph = graph(self)
	self._use = use(self)

	self._graph:update()
	return self
end

return Calc
