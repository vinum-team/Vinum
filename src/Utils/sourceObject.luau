--!strict
local class = {}
local meta = { __index = class }

function class:On(fn)
	self.listeners[fn] = true
end

function class:Fire(...)
    local data = {...}
    for listener in self.listeners do
        listener(data)
    end
end


return function(updater)
    local self = setmetatable({listeners = {}}, meta)
    updater(self)
    return self
end

--[[
    Source(function(self)
        if signal is constant then
            signal:Connect(function(...)
                self:fire({...})
            end)
        else
            do some Listen Tricks
        end
    end)
]]