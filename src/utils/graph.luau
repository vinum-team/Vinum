--!strict
local Utils = script.Parent
local LibraryRoot = Utils.Parent
local Types = require(LibraryRoot.types)

local class: Types.TGraph = {
	type = "utils",
	kind = "graph",
} :: any
local meta = { __index = class }
function class:updateDependents()
	for dependent in self.dependentSet do
		dependent:update()
	end
end

function class:disableDependencies()
	local myDependencies = self.dependencySet
	for obj in myDependencies do
		myDependencies[obj] = nil
		obj.dependentSet[self] = nil
	end
end

function class:simplifyDependencies()
	local myDependencies = self.dependencySet

	for dependency in myDependencies do
		for upperDependency in dependency.dependencySet do
			if not myDependencies[upperDependency] then
				continue
			end

			myDependencies[upperDependency] = nil
			upperDependency.dependentSet[self] = nil
		end
	end
end

function class:update()
	if not self.active then
		return false
	end
	local success = true
	local owner = self.owner
	local shouldSimplify
	if owner and owner._update then
		if owner._static then
			success = owner:_update()
		else
			local myDependencies = self.dependencySet
			-- STEP 1: Disable all dependencies
			for obj in myDependencies do
				myDependencies[obj] = nil
				obj.dependentSet[self] = nil
			end

			-- STEP 2: run the owner's _update method
			success, shouldSimplify = owner:_update()

			-- STEP 3: Simplify the dependency tree

			if shouldSimplify then
				for dependency in myDependencies do
					for upperDependency in dependency.dependencySet do
						if not myDependencies[upperDependency] then
							continue
						end

						myDependencies[upperDependency] = nil
						upperDependency.dependentSet[self] = nil
					end
				end
			end
		end
	end

	if success then
		for dependent in self.dependentSet do
			dependent:update()
		end
	end
	return success
end

local function Graph(owner: Types.TAnyState<any>?)
	return (
		setmetatable({
			owner = owner,
			dependencySet = {},
			dependentSet = {},
			active = true,
		}, meta) :: any
	) :: Types.TGraph
end

return Graph
