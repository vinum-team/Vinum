--!strict

local src = script.Parent.Parent
local types = require(src.types)
local Objects = src.Objects
local KeyOf = require(Objects.KeyOf)

local function unpackObject(obj: types.StateObj<any, { [any]: any }>, processors: { types.Processor<any> }, ...: any)
	local processTable = {}

	for i, info in { ... } do
		table.insert(processTable, KeyOf(obj, info, processors[i]))
	end

	return unpack(processTable)
end

return unpackObject
