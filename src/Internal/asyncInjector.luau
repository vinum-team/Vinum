--!strict

local types = require(script.Parent.Parent.types)
local task = (task or require("@lune/task")) :: any

local function coRunner(fn, taskRecord, ...)
	local info = fn(...)
	taskRecord.isFinished = true
	taskRecord.data = info

	if taskRecord.listener then
		taskRecord.listener(info)
	end
end

local class = {}
local meta = { __index = class }

function class:on(fn)
	if self.isFinished then
		fn(self.data)
		return
	end

	self.listener = fn
end

function class:cancel()
	self.isFinished = false
	if not (coroutine.status(self.coroutine) == "dead") then
		coroutine.close(self.coroutine)
	end
end

local function async<T>(fn, ...)
	local self = setmetatable({
		isFinished = false,
		listener = nil,
		data = nil,
		coroutine = coroutine.create(coRunner),
	}, meta)

	task.spawn(self.coroutine, fn, self, ...)

	return (self :: any) :: types.AsyncOperation<T>
end

local function asyncInjector(graph: types.Graph)
	return function(fn: () -> ()): types.AsyncOperation<any>
		local operation = async(fn)
		table.insert(graph.asyncOperations, operation)

		return operation
	end
end

return asyncInjector
