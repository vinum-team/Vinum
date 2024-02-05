--!strict
local Package = script.Parent.Parent
local types = require(Package.types)
local ShouldCacheValue = require(script.Parent.ShouldCacheValue)
local DebuggerHost = require(Package.DebuggerHost)

local function UpdateAll(disableDependentClearing: boolean, numberOfRoots: number, ...: types.RNode)
	local naiveDependentsQueue: { types.RNode }, naiveLength = { ... }, numberOfRoots
	local naivePos = 1

	-- first pass - We do a naive toposort where dependencies are placed before their dependents.
	while naivePos <= naiveLength do
		local myNext = naiveDependentsQueue[naivePos]
		if myNext.dependents then
			for dependent in myNext.dependents do
				table.insert(naiveDependentsQueue, dependent)
				naiveLength += 1
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

		table.insert(queue, myRNode)
		queueLength += 1
		flags[myRNode] = true
	end
	DebuggerHost.onSecondPass(queue, queueLength)

	-- third pass - We inversely read the queue resulted from the previous pass
	-- and update the RNode relating to the current Index. In the future, it is
	-- possible to ditch the previous passes when we are sure that a dependency
	-- tree hasn't changed since the last update.
	for i = queueLength, 1, -1 do
		local myRNode = queue[i]
		if myRNode.cancelableTasks then
			for _, ctask in myRNode.cancelableTasks do
				ctask:cancel()
			end

			myRNode.cancelableTasks = nil
		end

		if not disableDependentClearing then
			myRNode.dependents = nil
			myRNode.numOfDependents = 0
		end

		local rnodeOwner = myRNode.owner
		if rnodeOwner.onUpdate then
			rnodeOwner.onUpdate(rnodeOwner)
		end
	end

	for _, RNode in queue do
		if ShouldCacheValue(RNode) then
			continue
		end

		RNode.owner.value = nil

		if not RNode.cancelableTasks then
			continue
		end

		local newCancelableTasks = table.create(#RNode.cancelableTasks)
		for index, ctask in RNode.cancelableTasks do
			if not ctask.cleanable then
				table.insert(newCancelableTasks, ctask)
				continue
			end
			ctask:cancel()
		end

		RNode.cancelableTasks = newCancelableTasks
	end

	DebuggerHost.onThirdPass(queue, queueLength)
end

return UpdateAll
