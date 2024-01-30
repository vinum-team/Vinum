--!strict
local Package = script.Parent.Parent
local types = require(Package.types)

local function cancelAllCTasks(RNode: types.RNode)
    for _, ctask in RNode.cancelableTasks do
        ctask:cancel()
    end

    RNode.cancelableTasks = {}
end

local function UpdateAll(root: types.RNode)
    local prevDependents = root.dependents
    root.dependents = {}
    cancelAllCTasks(root)

    if root.owner.onUpdate then
        root.owner.onUpdate(root.owner)
    end

    for innerNode in prevDependents do
        UpdateAll(innerNode)
    end
end

return UpdateAll