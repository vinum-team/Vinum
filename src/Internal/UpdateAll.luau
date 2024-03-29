--!strict
local Package = script.Parent.Parent
local types = require(Package.types)
local ShouldCacheValue = require(script.Parent.ShouldCacheValue)

type ReactiveObject = types.ReactiveObject<any, any>

local function UpdateAll(
	disableDependentClearing: boolean,
	updateRoot: boolean,
	numberOfRoots: number,
	...: ReactiveObject
)
	local queue: { ReactiveObject | () -> () } = { ... }
	local length = numberOfRoots
	local pos = 1
	local lastOccurances = {}

	local rootLength = length

	while pos <= length do
		local currentObject = queue[pos]
		lastOccurances[currentObject] = pos
		if type(currentObject) == "table" and currentObject.dependents then
			for dependent in currentObject.dependents do
				length += 1
				queue[length] = dependent
			end
		end

		pos += 1
	end

	local toConditioanllyClean = {}

	for index, object in queue do
		if index <= rootLength and not updateRoot then
			continue
		end
		if lastOccurances[object :: any] ~= index then
			continue
		end

		if type(object) == "function" then
			object()
		else
			if object.cTasks then
				for _, ctask in object.cTasks do
					ctask:cancel()
				end
			end

			if not disableDependentClearing then
				object.dependents = nil
			end
			if object._computer then
				object.value = object._computer(object, object._arg)
				table.insert(toConditioanllyClean, object)
			end
		end
	end

	for _, object in toConditioanllyClean do
		if ShouldCacheValue(object) then
			continue
		end

		object.value = nil

		if object.cTasks then
			for _, cTask in object.cTasks do
				if cTask.cleanable then
					cTask:cancel()
				end
			end
		end
	end
	return queue, lastOccurances
end

return UpdateAll
