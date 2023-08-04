--!strict


--[=[
	@within Vinum

	A built-in utility that returns true if a and b are equal. However, since Vinum currently doesnt officially
	support immutabtility, all table entries are marked as inequal.

	```lua
	print(equals(1, 1)) -- true
	local sameTable = {}
	print(equals(sameTable, sameTable)) -- false
	```
]=]
local function equals(a: any, b: any): boolean
	-- INFO: Vinum doesn't officially support immutability currently- so, we just assume
	-- that every new table entry is not equal. See issue 26
	if type(a) == "table" then
		return false
	end

	return a == b
end

return equals