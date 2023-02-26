--!strict
local LibraryRoot = script.Parent.Parent
local Utils = LibraryRoot.Utils
local PubTypes = require(LibraryRoot.pubTypes)
local Types = require(LibraryRoot.types)
local Grapher = require(Utils.grapher)
local create = Grapher.create
local update = Grapher.updateGraph
local updateDependents = Grapher.updateDependents
local use = require(Utils.makeUseInjector)

local class: PubTypes.Absorb<unknown, unknown, unknown> = { type = "state", kind = "absorb", behavior = "self" } :: any
local meta = { __index = class }

--temp
local function alwaysTrue()
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

	if not self._processor(nil, self._value, newValue, false) then
		return false, false
	end

	self._value = newValue
	return true, shouldSimplifyTree
end

function class:_setValue(newValue)
	if not self._processor(nil, self._value, newValue, false) then
		return false
	end

	self._value = newValue
	updateDependents(self._graph)
	return true
end

return function<T, U, D>(
	toAbsorb: Types.TAnySelfState<D>,
	caseList: { [D | "default"]: Types.union<(use: Types.use<T>) -> U, Types.TAnySelfState<U>> },
	isSynced: Types.TAnySelfState<boolean>,
	processor: Types.TProcessor<U>?
)
	local self = (
		setmetatable({
			_static = false,
			_processor = alwaysTrue,
			_isSynced = isSynced,
			_caseList = caseList,
			_toAbsorb = toAbsorb,
		}, meta) :: any
	) :: PubTypes.Absorb<T, U, D>

	local myGraph = create(self)
	self._graph = myGraph

	toAbsorb._graph.dependentSet[myGraph] = true
	isSynced._graph.dependentSet[myGraph] = true

	self._use = use(self._graph)
	update(myGraph)
	self._processor = processor or alwaysTrue

	return self
end
