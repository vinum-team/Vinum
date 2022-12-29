local internalCleaner = require(script.internalCleaner)

--[=[
	@class Vinum

	The interface to Vinum's tools.
]=]
local Vinum = {}
--[=[
	@prop Hold () -> (Hold)
	@within Vinum

	Hold's constructor.
]=]
Vinum.Hold = require(script.Hold)
--[=[
	@prop Observe () -> (Observe)
	@within Vinum

	Observe's constructor.
]=]
Vinum.Observe = require(script.Observe)
--[=[
	@prop Calc () -> (Calc)
	@within Vinum

	Calc's constructor.
]=]
Vinum.Calc = require(script.Calc)
--[=[
	@prop Match () -> (Match)
	@within Vinum

	Match's constructor.
]=]
Vinum.Match = require(script.Match)
--[=[
	@prop Group () -> (Group)
	@within Vinum

	Group's constructor.
]=]
Vinum.Group = require(script.Group)
--[=[
	@prop Mirror () -> (Mirror)
	@within Vinum

	Mirror's constructor.
]=]
Vinum.Mirror = require(script.Mirror)
--[=[
	@prop Wrap () -> (Wrap)
	@within Vinum

	Wrap's constructor.
]=]
Vinum.Wrap = require(script.Wrap)
--[=[
	@prop Reflect () -> (Reflect)
	@within Vinum

	Reflect's constructor.
]=]
Vinum.Reflect = require(script.Reflect)
--[=[
	@prop Record () -> (Record)
	@within Vinum

	Record's constructor.
]=]
Vinum.Record = require(script.Record)

--[=[
	@prop AlwaysTrue (oldValue: T, newVallue: T) -> (true)
	@within Vinum

	A processor function that returns true every time it is called.
]=]
Vinum.AlwaysTrue = function()
	return true
end

--[=[
	@prop RefuseIfSimilar (oldValue: T, newVallue: T) -> (boolean)
	@within Vinum

	A processor function that returns true if the oldValue isn't equal to newValue
]=]
Vinum.RefuseIfSimilar = function(oldValue, newValue)
	if type(oldValue) == "table" and oldValue.value == "None" then
		return true
	end
	return oldValue ~= newValue
end

--[=[
	@prop RefuseIfSimilarAndCleanup (oldValue: T, newVallue: T) -> (boolean)
	@within Vinum

	A processor function that returns true if the oldValue isn't equal to newValue- plus, it will perform cleanup.
]=]
Vinum.RefuseIfSimilarAndCleanup = function(oldValue, newValue)
	local isDifferent = oldValue ~= newValue
	local isNotOnStartup = (type(oldValue) == "table" and oldValue.value == "None") == false

	if isDifferent and isNotOnStartup then
		internalCleaner(oldValue)
		return true
	else
		return false
	end
end

--[=[
	@prop RefuseIfSimilarInGroups (keyName: string, oldValue: T, newVallue: T) -> (boolean)
	@within Vinum

	Similar to `RefuseIfSimilar`, but modified to work with Groups.
]=]
Vinum.RefuseIfSimilarInGroups = function(_, oldValue, newValue)
	return Vinum.RefuseIfSimilar(oldValue, newValue)
end

--[=[
	@prop RefuseIfSimilarAndCleanupInGroup (keyName: string, oldValue: T, newVallue: T) -> (boolean)
	@within Vinum

	Similar to `RefuseIfSimilarAndCleanup`, but modified to work with Groups.
]=]
Vinum.RefuseIfSimilarAndCleanupInGroup = function(_, oldValue, newValue)
	return Vinum.RefuseIfSimilarAndCleanup(oldValue, newValue)
end

--[=[
	@prop Version {Major: number, Minor: number, Patch: number}
	@within Vinum

	The version that this build is based of.
]=]
Vinum.Version = {
	Major = 0,
	Minor = 2,
	Patch = 0,
}
--[=[
	@prop Destroy (stateObj) -> ()
	@within Vinum

	Destroys the given state object.
]=]
Vinum.Destroy = require(script.utils.deconstruct)

Vinum.read = require(script.utils.read)

return Vinum
