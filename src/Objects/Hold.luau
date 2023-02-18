--!strict
local LibraryRoot = script.Parent.Parent
local Utils = LibraryRoot.Utils
local PubTypes = require(LibraryRoot.pubTypes)
local Types = require(LibraryRoot.types)
local Grapher = require(Utils.grapher)
local create = Grapher.create 
local update = Grapher.updateGraph 

local class: PubTypes.Hold<unknown> = ({ type = "state", kind = "hold", behavior = "self" } :: any)
local meta = { __index = class }

function class:_setValue(newValue)
	if not self._processor(nil, self._value, newValue, false) then
		return false
	end

	
	self._value = newValue
	update(self._graph)
	return true
end

local function Hold<T>(initialValue: T, processor: Types.TProcessor<T>)
	local self = (
		setmetatable({
			_isWritable = true,
			_static = true,
			_value = initialValue,
			_processor = processor,
		}, meta) :: any
	)::PubTypes.Hold<T>

	self._graph = create(self)

	return self
end

return Hold
