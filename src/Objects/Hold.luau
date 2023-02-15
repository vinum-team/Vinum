--!strict
local LibraryRoot = script.Parent.Parent
local Utils = LibraryRoot.Utils
local PubTypes = require(LibraryRoot.pubTypes)
local Graph = require(Utils.graph)

local class: PubTypes.Hold<unknown> = ({ type = "state", kind = "hold", behavior = "self" } :: any)
local meta = { __index = class }

function class:_setValue(newValue)
	if not self._processor(self._value, newValue) then
		return false
	end

	
	self._value = newValue
	self._graph:update()
	return true
end

local function Hold<T>(initialValue: T, processor: (oldValue: T, newValue: T) -> boolean)
	local self = (
		setmetatable({
			_isWritable = true,
			_static = true,
			_value = initialValue,
			_processor = processor,
		}, meta) :: any
	)::PubTypes.Hold<T>

	self._graph = Graph(self)

	return self
end

return Hold
