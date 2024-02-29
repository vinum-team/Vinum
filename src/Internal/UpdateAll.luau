--!strict
local Package = script.Parent.Parent
local types = require(Package.types)
local ShouldCacheValue = require(script.Parent.ShouldCacheValue)

local function UpdateAll(disableDependentClearing: boolean, numberOfRoots: number, ...: types.ReactiveObject<any>)
	local queue: { types.ReactiveObject<any> | () -> () } = { ... }
	local length = numberOfRoots
	local pos = 1
	local lastOccurances = {}

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
		if lastOccurances[object :: any] ~= index then
			continue
		end

		if type(object) == "function" then
			object()
		else
			if object.cTasks then
				for _, cTask in object.cTasks do
					if cTask.cleanable == false then
						continue
					end
					cTask:cancel()
				end
			end

			if not disableDependentClearing then
				object.dependents = nil
			end
			if object._computer then
				object.value = object._computer(object)
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
