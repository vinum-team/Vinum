local graph = require(script.Parent.utils.graph)
local useState = require(script.Parent.utils.useState)
local useKeyState = require(script.Parent.utils.useKeyState)
local Symbols = require(script.Parent.utils.Symbols)

local class = {}
local meta = { __index = class }

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

return function(calculator, updateProcessor)
	local self = setmetatable({
		type = "state",
		kind = "calc",
		
		_isStaticDependency = false,
		_isSelfContained = true,
		_calculator = calculator,
		_value = Symbols.None,
		_updateProcessor = updateProcessor,
		_graph = {},
	}, meta)

	self._graph = graph(self)
	self._useHelper = useState(self)
	self._useKeyHelper = useKeyState(self)

	self:_update()
	return self
end
