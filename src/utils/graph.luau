--[[
    A class for managing reactive graphs to enable multi-graph 
    user-end objects such as Matches/Switches and stores.
]]

local class = {}
local META = {__index = class}
local WEAK_KEYS_METATABLE = {__mode = "k"}

function class:update(newValue)

    -- update dependents

    for dependent, isActive in self._dependentSet do
        if not isActive then continue end

        dependent:_update(newValue)
    end
end

function class:addDependent(dependent)
    self._dependentSet[dependent] = true
end

function class:addDependency(dependency)
    self._dependencySet[dependency] = true
end

return function()
   local self = setmetatable({
    type = "internalUtils",
    kind = "graph",

    _dependencySet = {},
    _dependentSet = setmetatable({}, WEAK_KEYS_METATABLE)
   }, META) 
   return self
end