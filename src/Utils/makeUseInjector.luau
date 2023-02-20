local Utils = script.Parent
local LibraryRoot = Utils.Parent
local Types = require(LibraryRoot.types)

local function readAndType<T>(
	state: Types.CanBeState<T> | Types.TAnyCentralState<T> | T,
	key: Types.maybeStringOrNumber?
): T
	if type(state) == "table" then
		local behaviorField = state.behavior
		if behaviorField == "central" then
			return (state :: Types.TAnyCentralState<T>)._values[key], "central"
		elseif behaviorField == "self" then
			return (state :: Types.TAnySelfState<T>)._value, "self"
		else
			return (state :: any) :: T, "raw"
		end
	end

	return state :: T, "raw"
end

local function constructor(self: Types.TAnySelfState<any>)
	local myGraph = self._graph
	local function use<T>(dependency: Types.TAnyCentralState<T> | Types.CanBeState<T>, key: string | number): T
		local value, typeState = readAndType(dependency, key)

		if typeState == "central" then
			local dependencyGraph = (dependency :: Types.TAnyCentralState<T>)._graphs[key]
			dependencyGraph.dependentSet[myGraph] = true
			myGraph.dependencySet[dependencyGraph] = true
		elseif typeState == "self" then
			local dependencyGraph = (dependency :: Types.TAnySelfState<T>)._graph
			dependencyGraph.dependentSet[myGraph] = true
			myGraph.dependencySet[dependencyGraph] = true
		end

		return value
	end

	return use
end

return constructor
