--!strict

--[=[
   @within Vinum

   A function that takes an undefined number of arguments, and always return true.
]=]
local function alwaysTrue(...: any): true
    return true
end

return alwaysTrue