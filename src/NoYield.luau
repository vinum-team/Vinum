local function NoYield(object)
	if object._noYield ~= nil then
		object._noYield = true
	end
	return object
end

return NoYield
