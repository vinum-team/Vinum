local function isDifferent(keyName, oldValue, newValue)
	if newValue then
		return oldValue ~= newVallue
	else
		return keyName ~= oldValue
	end
end

return isDifferent
