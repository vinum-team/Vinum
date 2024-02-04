--!strict
local Package = script.Parent.Parent
local types = require(Package.types)

local function ShouldCacheValue(RNode: types.RNode)
	if RNode.dependents then
		local areAlliListeners = true
		for dependent in RNode.dependents do
			if dependent.owner.type ~= "iListener" then
				areAlliListeners = false
				break
			end
		end

		return not areAlliListeners
	else
		return true
	end
end

return ShouldCacheValue
