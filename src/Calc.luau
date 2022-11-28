local graph = require(script.Parent.utils.graph)
local useState = require(script.Parent.utils.useState)
local useKeyState = require(script.Parent.utils.useKeyState)
local Symbols = require(script.Parent.utils.Symbols)
local class = { type = "state", kind = "calc" }
local meta = { __index = class }

type useStateType = typeof(useState())
type useKeyStateType = typeof(useKeyState())

export type Calc<T> = {
	type: "state",
	kind: "calc",

	_isStaticDependency: false,
	_isSelfContained: true,
	_calculator: (useState: useStateType, useKeyState: useKeyStateType) -> (T),
	_value: { type: "Symbol", value: "None"} | T,
	_updateProcessor: (oldValue: T, newValue: T) -> (boolean),
	_graph: typeof(graph()),
	_useHelper: useStateType,
	_useKeyHelper: useKeyStateType,
	_update: (self: Calc<T>) -> (T | nil),
	get: (self: Calc<T>) -> (T)
}


function class:_update()
	local oldValue = self._value
	self._value = Symbols.Pending
	local newValue = self._calculator(self._useHelper, self._useKeyHelper)

	if self._updateProcessor(oldValue, newValue) then
		self._value = newValue
		return self._value
	else
		self._value = oldValue
		return nil
	end
end

function class:get()
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
		_useHelper = {} :: typeof(useState()),
		_useKeyHelper = {} :: typeof(useKeyState()),
	}, meta)

	self._graph = graph(self)
	self._useHelper = useState(self)
	self._useKeyHelper = useKeyState(self)

	self._graph:update()
	return self
end

return Calc
