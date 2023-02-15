--!strict
local LibraryRoot = script.Parent.Parent
local Utils = LibraryRoot.Utils
local Types = require(LibraryRoot.types)
local PubTypes = require(LibraryRoot.pubTypes)
local Graph = require(Utils.graph)
local Spawn = require(Utils.spawner)

local class: PubTypes.Observe<unknown> = { type = "state", kind = "observe", behavior = "self" } :: any
local meta = { __index = class }

function class:_update()
	local value = (self :: PubTypes.Observe<unknown>)._owner._value

	if not (self :: PubTypes.Observe<unknown>)._processor(value) then
		return false, false
	end

	for fn in (self :: PubTypes.Observe<unknown>)._connections do
		Spawn(fn, value)
	end
	return true, false
end

function class:onChange(fn)
	self._connections[fn] = true

	return function()
		self._connections[fn] = nil
	end
end

function class:onBind(fn)
	fn(self._owner._value)

	return self:onChange(fn)
end

local function Observe<T>(owner: Types.TAnySelfState<T>, processor: (newValue: any) -> boolean)
	local self = setmetatable({
		_isWritable = false,
		_isYieldable = true,
		_static = true,
		_connections = {},
		_owner = owner,
		_processor = processor
	}, meta) :: any

	local graph = Graph(self)
	local ownerGraph = owner._graph
	self._graph = graph

	graph.dependencySet[ownerGraph] = true
	ownerGraph.dependentSet[graph] = true

	return self :: PubTypes.Observe<T>
end

return Observe
