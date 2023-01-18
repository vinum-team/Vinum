local graph = require(script.Parent.utils.graph)
local use = require(script.Parent.utils.use)

--[=[
	@class Calc

	```lua
	function Calc<T>(
		calculator: (use) -> (T), -- The function that Calc will use to perform calculations
		updateProcessor: (T, T) -> (boolean) -- The function that Calc will use to determine whether to let updates pass or not
	)
	```
	Constructs a new Calc object, which is used for deriving values from dependencies.
]=]
local class = { type = "state", kind = "calc" }
local meta = { __index = class }

function class:_update()
	local newValue = self._calculator(self._use)

	local toReturn = true
	if self._isInit then
		if self._updateProcessor(self._value, newValue) then
			self._value = newValue
		else
			toReturn = false
		end
	else
		self._value = newValue
		self._isInit = true
	end

	return toReturn
end

function class:_setValue(newValue: any)
	if not self._isWritable or not self._updateProcessor(self._value, newValue) then
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
		_calculator = calculator,
		_updateProcessor = updateProcessor,
		_graph = {} :: typeof(graph()),
		_onInit = false,
		_isWritable = false,
	}, meta)

	self._graph = graph(self)
	self._use = use(self)

	self._graph:update()
	return self
end

return Calc
