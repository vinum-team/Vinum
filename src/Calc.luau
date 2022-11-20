local graph = require(script.Parent.utils.graph)
local useState = require(script.Parent.utils.useState)

local class = {}
local meta = { __index = class }

local none = { value = "none" }

function class:_update()
	self._graph:deactivateAllDependenciesAndDependents()

	local oldValue = self._value
	local newValue = self._calculator(self._useHelper)

	self._graph:simplifyDependencyTree()

	if self._updateProcessor(oldValue, newValue) then
		self._value = newValue
		self._graph:update(newValue)
	end
end

function class:get()
	return self._value
end

return function(calculator, updateProcessor)
	local self = setmetatable({
		type = "state",
		kind = "calc",

		_calculator = calculator,
		_value = none,
		_updateProcessor = updateProcessor,
		_graph = {}
	}, meta)

	self._graph = graph(self)
	self._useHelper = useState(self)

	self:_update()
	return self
end
