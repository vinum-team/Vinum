--[[
    A class for managing reactive graphs to enable multi-graph 
    user-end objects such as Matches/Switches and stores.
]]

local class = {}
local META = { __index = class }
local WEAK_KEYS_METATABLE = { __mode = "k" }

function class:update(newValue)
	-- update dependents
	for dependent, isActive in self._dependentSet do
		if not isActive then
			continue
		end

		dependent:_update(newValue)
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
		if not dependency._isSelfContained then continue end

		for upperDependency in dependency._graph._dependencySet do
			if self._dependencySet[upperDependency] then
				self._dependencySet[upperDependency] = false
				upperDependency._graph[self._owner] = false
			end
		end
	end
end

function class:deactivateAllDependenciesAndDependents()
	for dependency in self._dependencySet do
		if not dependency._isSelfContained then continue end
		self._dependencySet[dependency] = false
		dependency._graph._dependentSet[self._owner] = false
	end

	for dependent in self._dependentSet do
		dependent._graph._dependencySet[self._owner] = false
		self._dependentSet[dependent] = false
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
