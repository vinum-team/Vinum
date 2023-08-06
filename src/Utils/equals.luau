--!strict

local function equals(a: any, b: any): boolean
	-- INFO: Vinum doesn't officially support immutability currently- so, we just assume
	-- that every new table entry is not equal. See issue 26
	if type(a) == "table" then
		return false
	end

	return a == b
end

return equals
