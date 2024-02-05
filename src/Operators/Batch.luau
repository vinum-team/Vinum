--!strict
local Package = script.Parent.Parent
local Internal = Package.Internal
local UpdateAll = require(Internal.UpdateAll)

local function Batch(...)
	local array = { ... }
	local arrayLength = #array
	local rnodes = {}
	local rnodesLength = 0
	for i = 1, arrayLength, 2 do
		local object = array[i]
		local data = array[i + 1]

		table.insert(rnodes, object.node)
		rnodesLength += 1
		object.value = data
	end

	UpdateAll(false, rnodesLength, table.unpack(rnodes))
end

return Batch
