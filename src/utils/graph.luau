--[[
    A class for managing reactive graphs to enable multi-graph 
	objects, Groups are an example of a multi-graph object.
]]
local class = {}
local META = { __index = class }

function class:updateDependents()
	for dependent, state in self._dependentSet do
		if state ~= true then
			continue
		end

		dependent:update()
	end
end
function class:update(newValue)
	local owner = self._owner
	local shouldContinue
	if owner and owner._update then
		if owner._isStaticDependency then
			shouldContinue = self._owner:_update()
		else
			self:deactivateAllDependencies()
			shouldContinue = self._owner:_update()
			self:simplifyDependencyTree()
		end

		if not shouldContinue then
			return false
		end
	end

	self:updateDependents()
	return true
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
	for dependency, state in self._dependencySet do
		self._dependencySet[dependency] = false
		dependency._dependentSet[self] = false
	end
end

--[[
	Both addX methods are considered technical dept and will be removed once
	it is proved these methods aren't used anymore in Vinum's codebase.
]]
function class:addDependent(dependent)
	self._dependentSet[dependent] = true
end

function class:addDependency(dependency)
	self._dependencySet[dependency] = true
end

return function(owner)
	local self = setmetatable({
		type = "internalUtils",
		kind = "graph",

		_owner = owner,
		_dependencySet = {},
		_dependentSet = {},
	}, META)
	return self
end
