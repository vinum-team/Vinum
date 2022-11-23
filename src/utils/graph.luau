--[[
    A class for managing reactive graphs to enable multi-graph 
    user-end objects such as Matches/Switches and stores.
]]

local class = {}
local META = { __index = class }
local WEAK_KEYS_METATABLE = { __mode = "k" }

function class:update(newValue)
	if self._owner._update then
		self:deactivateAllDependencies()
		newValue = self._owner:_update(newValue) or newValue
		self:simplifyDependencyTree()
	end
	-- update dependents
	for dependent, isActive in self._dependentSet do
		if not isActive then
			continue
		end

		dependent:update(newValue)
	end
end

function class:addDependent(dependent)
	self._dependentSet[dependent] = true
end

function class:addDependency(dependency)
	self._dependencySet[dependency] = true
end

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

function class:deactivateAllDependencies()
	for dependency in self._dependencySet do
		if not dependency._isSelfContained then continue end
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
