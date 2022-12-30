return function(state, keyName)
	if keyName then
		return state:_getValue(keyName)
	else
		return state:_getValue()
	end
end
