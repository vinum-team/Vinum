--!strict
local class = {}
local meta = { __index = class }

function class:On(fn)
	self.listeners[fn] = true
end

function class:Fire(...)
	local data = { ... }
	for listener in self.listeners do
		listener(data)
	end
end

local function sourceObject(updater)
	local self = setmetatable({ listeners = {} }, meta)
	updater(self)
	return self
end

return sourceObject
