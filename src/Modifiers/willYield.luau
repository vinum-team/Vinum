--!strict
local pubTypes = require("../pubTypes")


--[=[
	@within Vinum

	When called on a Listen, it determines whether a Listen object should run its connections on a new thread, 
	or the current one.
]=]
local function willYield(listen: pubTypes.Listen<any>, value: boolean): pubTypes.Listen<any>
	listen._canYield = value

	return listen
end

return willYield