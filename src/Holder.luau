local class = {}
local meta = {__index = class}

function class:_update(newValue)
    self._value = newValue

    for dependent, isActive in self._dependentSet do 
        if not isActive then continue end

        dependent:_update()
    end
end

function class:get()
    return self._value
end

function class:set(newValue)
    local shouldUpdate = self._updateProccessor(self._value, newValue)

    if shouldUpdate then
        self:_update(newValue)
    end
end

return function(ogValue, updateProcessor)
    local self = setmetatable({
        _value = ogValue,
        _dependentSet = {},
        _updateProccessor = updateProcessor
    }, meta)

    self:_update(ogValue)
    return self
end
