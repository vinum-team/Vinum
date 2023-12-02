--!strict
local Package = script.Parent.Parent
local types = require(Package.types)

type Node = types.Node

local function Node(owner: types.State<any>): types.Node
	return {
		owner = owner,
		dependents = {},
		cancelableTasks = {},
	}
end

local function cancelAllTasksFor(Node: Node)
	for _, cTask in Node.cancelableTasks do
		cTask:cancel()
	end
end

-- Credit: https://blog.elttob.uk/2022/11/07/sets-efficient-topological-search.html
local function _updateAll(root: Node)
	local counters: { [Node]: number } = {}
	local flags: { [Node]: boolean } = {}
	local queue: { Node } = {}
	local queueSize = 0
	local queuePos = 1

	for object in root.dependents do
		queueSize += 1
		queue[queueSize] = object
		flags[object] = true
	end

	-- Pass 1: counting up
	while queuePos <= queueSize do
		local next = queue[queuePos]
		local counter = counters[next]
		counters[next] = if counter == nil then 1 else counter + 1
		for object in next.dependents do
			queueSize += 1
			queue[queueSize] = object
		end
		queuePos += 1
	end

	-- Pass 2: counting down + processing
	queuePos = 1
	while queuePos <= queueSize do
		local next = queue[queuePos]
		local counter = counters[next] - 1
		counters[next] = counter
		if
			counter == 0
			and flags[next]
			and cancelAllTasksFor(next)
			and next.owner.update ~= nil
			and (next :: any).owner:update(next)
			and next.dependents ~= nil
		then
			for object in next.dependents do
				flags[object] = true
			end
		end
		queuePos += 1
	end
end

local function updateAll(root: Node)
	for innerNode in root.dependents do
		cancelAllTasksFor(innerNode)
		if innerNode.owner.update then
			innerNode.owner.update(innerNode.owner)
		end
		updateAll(innerNode)
	end
end

return {
    Node = Node,
    updateAll = updateAll
}