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

local class: PubTypes.Compute<unknown> = { type = "state", kind = "compute", behavior = "self" } :: any
local meta = { __index = class }

function class:_update()
    local newValue = self._computer(self._use)
    if not self._processor(nil, self._value, newValue, false) then
        return false, false
    end

    self._value = newValue
    return true, true
end

function class:_setValue(value)
    if not self._processor(nil, self._value, value, false) then
        return false
    end

    self._value = value
    updateDependents(self._graph)
    return true
end

return function<T, U>(computer: (use: Types.use<T>) -> U, processor: Types.TProcessor<U>)
    local self = (setmetatable({
        _processor = processor,
        _computer = computer
    }, meta):: any):: PubTypes.Compute<U>

    local Graph = create(self)
    self._graph = Graph
    self._use = use(self)
    update(Graph)
    return self
end
