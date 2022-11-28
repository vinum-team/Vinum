local graph = require(script.Parent.utils.graph)
local spawner = require(script.Parent.utils.spawner)
local Symbols = require(script.Parent.utils.Symbols)
local class = { type = "state", kind = "group" }
local meta = { __index = class }

local selfContainedClass = { __index = {
	get = function(self)
		return self._graph._owner._values[self.name]
	end,
} }
function class:setKey(keyName: string, keyValue: any)
	local values = self._values
	local oldValue = values[keyName]  or Symbols.None
	if self._setProcessor(keyName, oldValue, keyValue) then
		if values[keyName] then
			values[keyName] = keyValue
			self._graphs[keyName]:update(keyValue)
		else
			values[keyName] = keyValue
			self._graphs[keyName] = graph(self)
		end

		for connection in self._connections do
			spawner(connection, keyName, oldValue , keyValue)
		end
	end
end

function class:getKey(keyName: string)
	return self._values[keyName]
end

function class:asState(KeyName: string)
	return setmetatable({ name = KeyName, _graph = self._graphs[KeyName] }, selfContainedClass)
end

function class:onChange(fn)
	self._connections[fn] = true

	return function()
		self._connections[fn] = nil
	end
end

local function Group(setProcessor: (keyName: string, oldKeyValue: unknown, keyValue: unknown) -> (boolean))
	local self = setmetatable({
		_isStaticDependency = false,
		_isSelfContained = false,
		_setProcessor = setProcessor,
		_values = {},
		_graphs = {},
		_connections = {},
	}, meta)
	return self
end

return Group
