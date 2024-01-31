--!strict
local Package = script.Parent.Parent
local types = require(Package.types)

local function cancelAllCTasks(RNode: types.RNode)
	for _, ctask in RNode.cancelableTasks do
		ctask:cancel()
	end

	RNode.cancelableTasks = {}
end

local function UpdateAll(root: types.RNode, disableDependentClearing: boolean?)
	local naiveDependentsQueue: { types.RNode }, naiveLength = { root }, 1
	local naivePos = 1

	-- first pass - We do a naive toposort where dependencies are placed before their dependents.
	while naivePos <= naiveLength do
		local myNext = naiveDependentsQueue[naivePos]
		for dependent in myNext.dependents do
			table.insert(naiveDependentsQueue, dependent)
			naiveLength += 1
		end
		naivePos += 1
	end

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

	-- third pass - We inversely read the queue resulted from the previous pass
	-- and update the RNode relating to the current Index. In the future, it is
	-- possible to ditch the previous passes when we are sure that a dependency
	-- tree hasn't changed since the last update.
	for i = queueLength, 1, -1 do
		local myRNode = queue[i]
		cancelAllCTasks(myRNode)

		if not disableDependentClearing then
			myRNode.dependents = {}
		end
		if myRNode.owner.onUpdate then
			myRNode.owner.onUpdate(myRNode.owner)
		end
	end
end

return UpdateAll
