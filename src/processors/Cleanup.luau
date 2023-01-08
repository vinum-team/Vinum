local internalCleaner = require(script.Parent.Parent.internalCleaner)

local function cleanup(keyName, oldValue, newValue)
	if newValue then
		internalCleaner(oldValue)
	else
		internalCleaner(keyName) -- in this case, keyName is the oldValue
	end

	return true
end

return cleanup
