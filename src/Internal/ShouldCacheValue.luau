--!strict
local Package = script.Parent.Parent
local types = require(Package.types)
local DebuggerHost = require(Package.DebuggerHost)

local function ShouldCacheValue(RNode: types.ReactiveObject<any>)
	if RNode.dependents then
		local areAlliListeners = true
		for dependent in RNode.dependents do
			if type(dependent) ~= "function" then
				areAlliListeners = false
				break
			end
		end

		DebuggerHost.onShouldCacheValue(RNode, not areAlliListeners)
		return not areAlliListeners
	else
		DebuggerHost.onShouldCacheValue(RNode, true)
		return true
	end
end

return ShouldCacheValue
