--!strict
local LibraryRoot = script.Parent.Parent
local Utils = LibraryRoot.Utils
local PubTypes = require(LibraryRoot.pubTypes)
local Grapher = require(Utils.grapher)
local Types = require(LibraryRoot.types)
local create = Grapher.create
local update = Grapher.updateGraph
local class: PubTypes.Group<any> = { type = "state", kind = "group", behavior = "central" } :: any
local meta = { __index = class }

function class:_setValue(key, newValue)
	local valuesLocation = self._values
	local oldValue = valuesLocation[key]

	if not self._processor(key, oldValue, newValue, false) then
		return false
	end

	if oldValue then
		valuesLocation[key] = newValue
		update(self._graphs[key])
	else
		valuesLocation[key] = newValue
		local graph = create(self)
		self._graphs[key] = graph

		update(graph)
	end
	return true
end

return function<T>(initialValue: T, processor: Types.TProcessor<any>)
	local self = (
		setmetatable({
			_isWritable = true,
			_static = true,
			_values = initialValue,
			_processor = processor,
			_graphs = {},
		}, meta) :: any
	) :: PubTypes.Group<T>

	local graphs = self._graphs
	for key in initialValue :: any do
		graphs[key] = create(self)
	end

	return self
end
