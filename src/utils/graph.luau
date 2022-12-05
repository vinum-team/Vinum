--[[
    A class for managing reactive graphs to enable multi-graph 
	objects, Groups are an example of a multi-graph object.
]]

local class = {}
local META = { __index = class }
local WEAK_KEYS_METATABLE = { __mode = "k" }

function class:update(newValue)
	local owner = self._owner
	if owner and owner._update then
		if owner._isStaticDependency then
			newValue = self._owner:_update(newValue) or newValue
		else
			self:deactivateAllDependencies()
			newValue = self._owner:_update(newValue) or newValue
			self:simplifyDependencyTree() 
		end
	end
	-- update dependents
	for dependent, isActive in self._dependentSet do
		if not isActive then
			continue
		end

		dependent:update(newValue)
	end
end

--[[
	Tree simplification is done by disconnecting any bonds
	with dependencies that we already have an indirect bond with.
	i.e, A, B, and C - B and C depend on A, while C also depends on B
	if A changes, it means B will change too, so C will get updated twice
	We solved this issue by disconnecting AC bond,
]]
function class:simplifyDependencyTree()
	for dependency in self._dependencySet do
		for upperDependency in dependency._dependencySet do
			if self._dependencySet[upperDependency] then
				self._dependencySet[upperDependency] = false
				upperDependency._dependentSet[self] = false
			end
		end
	end
end

--[[
	We deactivate all dependencies before dependency capturing - this is to allow
	"native" lazy evaluation, which means that lazy evaluation is mostly done by Luau!

	Also, it is hard-coded that we don't deactivate centralized state containers, that is Groups. This 
	generally because they don't hold dependencies.
]]
function class:deactivateAllDependencies()
	for dependency in self._dependencySet do
		if not dependency._isSelfContained then
			continue
		end
		self._dependencySet[dependency] = false
		dependency._dependentSet[self] = false
	end
end

return function(owner)
	local self = setmetatable({
		type = "internalUtils",
		kind = "graph",

		_owner = owner,
		_dependencySet = {},
		_dependentSet = setmetatable({}, WEAK_KEYS_METATABLE),
	}, META)
	return self
end