local graph = require(script.Parent.utils.graph)
local use = require(script.Parent.utils.use)
local become = require(script.Parent.utils.become)

local class = { type = "state", kind = "progress" }
local meta = { __index = class }

local function ProgressUpdater(self)
	local newValue = self._calculator(self._use, self._become)

	if self._updateProcessor(self._value, newValue) then
		self._value = newValue
		self:_setValue(newValue)
		return true
	end

	return false
end

function class:_update()
	if self._job and coroutine.status(self._job) ~= "dead" then
		coroutine.close(self._job)
	end

	local job = coroutine.create(ProgressUpdater)
	self._job = job
	task.spawn(job, self)
	return false
end

function class:_setValue(newValue: any)
	self._value = newValue
	self._graph:updateDependents()
end

function class:_getValue()
	return self._value
end

local function Progress<T>(initialState: T, calculator, updateProcessor)
	local self = setmetatable({
		_isStaticDependency = false,
		_calculator = calculator,
		_value = initialState,
		_updateProcessor = updateProcessor,
		_graph = {} :: typeof(graph()),
		_onInit = true,
		_isWritable = true,
	}, meta)

	self._graph = graph(self)
	self._use = use(self)
	self._become = become(self)
	self._graph:update()
	return self
end

return Progress
