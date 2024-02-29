--!strict
local Package = script.Parent.Parent
local types = require(Package.types)
local ShouldCacheValue = require(script.Parent.ShouldCacheValue)
local DebuggerHost = require(Package.DebuggerHost)

local function UpdateAll(disableDependentClearing: boolean, numberOfRoots: number, ...: types.ReactiveObject<any>)
	local naiveDependentsQueue: { types.ReactiveObject<any> | () -> () }, naiveLength = { ... }, numberOfRoots
	local naivePos = 1

	-- first pass - We do a naive toposort where dependencies are placed before their dependents.
	while naivePos <= naiveLength do
		local myNext = naiveDependentsQueue[naivePos]
		if type(myNext) == "table" and myNext.dependents then
			for dependent in myNext.dependents do
				naiveLength += 1
				naiveDependentsQueue[naiveLength] = dependent
			end
		end
		naivePos += 1
	end

	DebuggerHost.onFirstPass(naiveDependentsQueue, naiveLength)

	-- second pass - We inversely read the result from the naive toposort
	-- and record only the first occurrence of every RNode, and disregard
	-- any other occurrence.
	local flags = {}
	local queue = {}
	local queueLength = 0
	for i = naiveLength, 1, -1 do
		local myRNode = naiveDependentsQueue[i]
		if flags[myRNode] then
			continue
		end

		queueLength += 1
		queue[queueLength] = myRNode
		flags[myRNode] = true
	end
	DebuggerHost.onSecondPass(queue, queueLength)

	-- third pass - We inversely read the queue resulted from the previous pass
	-- and update the RNode relating to the current Index. In the future, it is
	-- possible to ditch the previous passes when we are sure that a dependency
	-- tree hasn't changed since the last update.
	for i = queueLength, 1, -1 do
		local myRNode = queue[i]
		if type(myRNode) == "function" then
			myRNode()
			continue
		end
		if myRNode.cTasks then
			for _, ctask in myRNode.cTasks do
				ctask:cancel()
			end

			myRNode.cTasks = nil
		end

		if not disableDependentClearing then
			myRNode.dependents = nil
		end

		if myRNode._computer then
			myRNode.value = myRNode._computer(myRNode)
		end
	end

	for _, RNode in queue do
		if type(RNode) == "function" then
			continue
		end
		if ShouldCacheValue(RNode) then
			continue
		end

		RNode.value = nil

		if not RNode.cTasks then
			continue
		end

		local newCancelableTasks = table.create(#RNode.cTasks)
		for index, ctask in RNode.cTasks do
			if not ctask.cleanable then
				table.insert(newCancelableTasks, ctask)
				continue
			end
			ctask:cancel()
		end

		RNode.cTasks = newCancelableTasks
	end

	DebuggerHost.onThirdPass(queue, queueLength)
end

return UpdateAll
