--!strict
local types = require("../types")

--[=[
	@within Vinum

	Changes whether a state object is writable.
	```lua
		local maxHealth = Hold(100, alwaysTrue)

		local WritableHealth = Writable(Compute(function(use)
			return use(maxHealth)
		end,alwaysTrue))

		maxHealth:set(50) -- WritableHealth is now 50

		WritableHealth:set(WritableHealth:get() - 10) -- WritableHealth is now 40.
	```
]=]
local function isWritable(stateObject: types.StateObj<any, any>, value: boolean): types.StateObj<any, any>
	stateObject._writable = value

	return stateObject 
end

return isWritable