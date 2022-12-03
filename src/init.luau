local internalCleaner = require(script.internalCleaner)

local Vinum =  {
	Hold = require(script.Hold),
	Observe = require(script.Observe),
	Calc = require(script.Calc),
	Match = require(script.Match),
	Group = require(script.Group),
	Mirror = require(script.Mirror),
	Wrap = require(script.Wrap),
	AlwaysTrue = function()
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
	end,

}

Vinum.RefuseIfSimilarInGroups = function(_,oldValue, newValue)
	return Vinum.RefuseIfSimilar(oldValue, newValue)
end
Vinum.RefuseIfSimilarAndCleanupInGroup = function(_, oldValue, newValue)
	return Vinum.RefuseIfSimilarAndCleanup(oldValue, newValue)
end
return Vinum