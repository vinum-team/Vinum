--!strict
local LibraryRoot = script.Parent.Parent
local Utils = LibraryRoot.Utils
local PubTypes = require(LibraryRoot.pubTypes)
local Types = require(LibraryRoot.types)
local Graph = require(Utils.graph)
local use = require(Utils.makeUseInjector)

local class: PubTypes.Absorb<unknown> = { type = "state", kind = "absorb", behavior = "self" } :: any
local meta = { __index = class }

--temp
local function alwaysTrue(...)
	return true
end

function class:_update()
	if not self._isSynced._value then
		return false, false
	end
	local caseList = self._caseList
	local chosenArm = caseList[self._toAbsorb._value] or caseList["default"]

	local newValue

	local shouldSimplifyTree = true
	if type(chosenArm) == "table" then
		newValue = chosenArm._value
		local chosenGraph = chosenArm._graph

		local myGraph = self._graph

		chosenGraph.dependentSet[myGraph] = true
		myGraph.dependencySet[chosenGraph] = true

		shouldSimplifyTree = false
	else
		newValue = chosenArm(self._use)
	end

	if not self._processor(self._value, newValue) then
		return false, false
	end

	(self :: PubTypes.Absorb<unknown>)._value = newValue
	return true, shouldSimplifyTree
end

function class:_setValue(newValue)
	if not self._processor(self._value, newValue) then
		return false
	end

	self._value = newValue
	self._graph:updateDependents()
	return true
end

return function<T>(
	toAbsorb: Types.TAnySelfState<any>,
	caseList: { [any]: (any) -> () | Types.TAnySelfState<any> },
	isSynced: Types.TAnySelfState<boolean>,
	processor: ((oldValue: any, newValue: any) -> boolean)?
)
	local self = (
		setmetatable({
			_static = false,
			_processor = processor or alwaysTrue,
			_isSynced = isSynced,
			_caseList = caseList,
			_toAbsorb = toAbsorb,
		}, meta) :: any
	) :: PubTypes.Absorb<T>

	local myGraph = Graph(self)
	self._graph = myGraph

	toAbsorb._graph.dependentSet[myGraph] = true
	isSynced._graph.dependentSet[myGraph] = true

	self._use = use(self)
	myGraph:update()

	return self
end
