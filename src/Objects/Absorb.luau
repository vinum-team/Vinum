--!strict
local graph = require(script.Parent.Parent.Utils.graph)
local pubTypes = require(script.Parent.Parent.pubTypes)
local types = require(script.Parent.Parent.types)
local alwaysTrue = require(script.Parent.Parent.Utils.alwaysTrue)

--[[
    export type StateObj<M, T> = {
	meta: M,
	static: boolean,
	_value: T,
	_graph: Graph,
	_update: (self: StateObj<M, T>) -> ()?,
	_writable: boolean,

	set: (self: StateObj<M, T>, newValue: T) -> (),
	get: (self: StateObj<M, T>) -> T,
	_processor: Processor<T>,
}
export type Absorb<T, U> = types.Extends<types.StateObj<"Absorb", T>, {
	_toAbsorb: types.StateObj<any, U>,
	_cases: {[U | "default"]: types.CanBeState<T>}?
}>
]]

local class = {}
local meta = { __index = class }

function class:get()
	return self._value
end

function class:set(value)
    if not self._writable then
		return
	end

	if not self._processor(self._value, value, false) then
		return
	end

	self._value = value

	graph.run(self._graph, false, true)
end

function class:_update()
    local toAbsorb = self._toAbsorb
    local caseList = self._cases
    local valueContainer = caseList[toAbsorb._value] or caseList["default"]
    local value = valueContainer:get()

    if not self._processor(self._value, value, false) then
		return
	end

    local lastLastArm = self._lastArm
    if lastLastArm and lastLastArm ~= toAbsorb then
        local graph: types.Graph = self._lastArm
        local myGraph = self._graph
        graph.dependents[myGraph] = nil
        myGraph.dependencies[graph] = nil
    end

    local valueContainerGraph = valueContainer._graph
    local myGraph = self._graph

    valueContainerGraph.dependents[myGraph] = true
    myGraph.dependencies[valueContainerGraph] = true

    self._lastArm = valueContainerGraph
	self._value = value
end

return function<T, U>(
	toAbsorb: types.StateObj<any, U>,
	caseList: { [U | "default"]: types.StateObj<any, T> },
	processor: types.Processor<T>
): pubTypes.Absorb<T, U>
	local self = (
		setmetatable({
			meta = "Absorb",
			static = true,
			_writable = false,
			_processor = alwaysTrue,
			_toAbsorb = toAbsorb,
			_cases = caseList,
		}, meta) :: any
	) :: pubTypes.Absorb<T, U>

	local myGraph = graph.create(self)
	local toAbsorbGraph = toAbsorb._graph
    self._graph = myGraph

	myGraph.dependencies[toAbsorbGraph] = true
	toAbsorbGraph.dependents[myGraph] = true

    graph.run(myGraph, true, false)
	self._processor = processor
	return self
end
