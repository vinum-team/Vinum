return function(state, keyName)
	if type(state) ~= "table" and state.type ~= "state" then
		return state
	end
	if keyName then
		return state:_getValue(keyName)
	else
		return state:_getValue()
	end
end
