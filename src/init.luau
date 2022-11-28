local internalCleaner = require(script.internalCleaner)

return {
	Hold = require(script.Hold),
	Observe = require(script.Observe),
	Calc = require(script.Calc),
	Match = require(script.Match),
	Group = require(script.Group),
	JustOk = function()
		return true
	end,
	RefuseIfSimilar = function(oldValue, newValue)
		if type(oldValue) == "table" and oldValue.value == "None" then
			return true
		end
		return oldValue ~= newValue
	end,
	RefuseIfSimilarAndCleanup = function(oldValue, newValue)
		local isDifferent = oldValue ~= newValue
		local isNotOnStartup = (type(oldValue) == "table" and oldValue.value == "None") == false

		if isDifferent and isNotOnStartup then
			internalCleaner(oldValue)
			return true
		else
			return false
		end
	end
}
