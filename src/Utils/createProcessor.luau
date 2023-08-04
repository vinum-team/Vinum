--!strict
--[=[
	@within Vinum

	Creates a new Processor using a built-in template in Vinum. 

	Accepts a valueChecker, which is responsible for determining whether the new value is different than the older one, 
	and a cleaner function to destroy old values, and the current one when the object is being destroyed 
   
	Can be used to create a "default" processor for universal use within your codebase.

	```lua
	local function default(cleaner)
		return createProcessor(Vinum.equals, cleaner)
	end

	local NewInstance = Compute(function(use)
		local instance = Instance.new("Part")
		instance.Name = use(partName)
		return instance
	end, default(Vinum.clean))
	```

	
	@return Processor<T>
]=]
local function createProcessor(valueChecker: (a: any, b: any) -> boolean, cleaner: (taskItem: any) -> ())
	return function<T>(old: T, new: T, isDestroying: boolean)
		if isDestroying then
			cleaner(old)
			return false
		end

		if valueChecker(old, new) then
			return false
		end

		cleaner(old)
		return true
	end
end

return createProcessor
