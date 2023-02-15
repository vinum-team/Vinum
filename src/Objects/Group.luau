--!strict
local LibraryRoot = script.Parent.Parent
local Utils = LibraryRoot.Utils
local PubTypes = require(LibraryRoot.pubTypes)
local Graph = require(Utils.graph)

local class: PubTypes.Group<any> = { type = "state", kind = "group", behavior = "central" } :: any
local meta = { __index = class }

function class:_setValue(key, newValue)
	local valuesLocation = self._values
	local oldValue = valuesLocation[key]

	if not self._processor(key, oldValue, newValue) then
		return false
	end

	if oldValue then
		valuesLocation[key] = newValue
		self._graphs[key]:update()
	else 
		valuesLocation[key] = newValue
		local graph = Graph(self)
		self._graphs[key] = graph

		graph:update()
	end
	return true
end

return function<T>(
	initialValue: { [string | number]: T },
	processor: (key: string | number, oldValue: any, newValue: any) -> boolean
)
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
	for key in initialValue do
		graphs[key] = Graph(self)
	end

	return self
end
