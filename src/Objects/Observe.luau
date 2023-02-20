--!strict
local LibraryRoot = script.Parent.Parent
local Utils = LibraryRoot.Utils
local Types = require(LibraryRoot.types)
local PubTypes = require(LibraryRoot.pubTypes)
local Grapher = require(Utils.grapher)
local create = Grapher.create
local Spawn = require(Utils.spawner)

local class: PubTypes.Observe<unknown> = { type = "state", kind = "observe", behavior = "self" } :: any
local meta = { __index = class }

-- a pretty neat trick from Fusion to allow Observes to hold observed objects in memory while there are active connections
local StrongRefs: { [PubTypes.Observe<any>]: true } = {}

function class:_update()
	local value = (self :: PubTypes.Observe<unknown>)._owner._value

	if not (self :: PubTypes.Observe<unknown>)._processor(value) then
		return false, false
	end

	if not self._isYieldable then
		for fn in (self :: PubTypes.Observe<unknown>)._connections do
			fn(value)
		end
	else
		for fn in (self :: PubTypes.Observe<unknown>)._connections do
			Spawn(fn, value)
		end
	end
	return true, false
end

function class:onChange(fn)
	self._connections[fn] = true
	self._numOfConnections += 1

	StrongRefs[self] = true
	return function()
		self._connections[fn] = nil
		self._numOfConnections -= 1

		if self._numOfConnections <= 0 then
			StrongRefs[self] = nil
		end
	end
end

function class:onBind(fn)
	fn(self._owner._value)

	return self:onChange(fn)
end

local function Observe<T>(owner: Types.TAnySelfState<T>, processor: (newValue: any) -> boolean)
	local self = setmetatable({
		_isYieldable = false,
		_static = true,
		_connections = {},
		_owner = owner,
		_numOfConnections = 0,
		_processor = processor,
	}, meta) :: any

	local graph = create(self)
	local ownerGraph = owner._graph
	self._graph = graph

	graph.dependencySet[ownerGraph] = true
	ownerGraph.dependentSet[graph] = true

	return self :: PubTypes.Observe<T>
end

return Observe
