local function xtype(obj)
	local typeOf = type(obj)

	if typeOf == "table" and obj.type == "state" then
		typeOf = obj.type
	end

	return typeOf
end

return function(state, keyName)
	if xtype(state) ~= "state" then
		return state
	end
	
	if keyName then
		return state:_getValue(keyName)
	else
		return state:_getValue()
	end
end
