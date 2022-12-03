local graph = require(script.Parent.utils.graph)
local class = { type = "state", kind = "wrap" }
local meta = { __index = class }
local Symbols = require(script.Parent.utils.Symbols)

function class:get()
	if self._disconnected == true then
		error("[Vinum] Trying to read a disconnected Wrap object's value.", 2)
	end
	return self._value
end
--[[
    Since Wrap supports RBXScriptSignals, Users should be able to explicitly disconnect
    the connection Wrap created.
]]
function class:disconnect()
	self._disconnected = true
	self._internalConnection:Disconnect()
end

local function Wrap(
	Signal: RBXScriptSignal | {
		Connect: (fn: (...any) -> ()) -> (any),
	},
	numOfArguments: number,
	...: any
)
	local states = table.create(numOfArguments)

	for i = 1, numOfArguments do
		local self = setmetatable({
			_disconnected = false,
			_isSelfContained = true,
			_isStaticDependency = true,
			_value = select(i, ...) or Symbols.None ,
			_graph = {},
		}, meta)

		self._graph = graph(self)

		self._internalConnection = (Signal :: any):Connect(function(...)
			self._value = select(i, ...)
			self._graph:update()
		end)

		table.insert(states, self)
	end

	return table.unpack(states)
end

return Wrap
