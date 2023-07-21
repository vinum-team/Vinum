--!strict
local pubTypes = require(script.Parent.Parent.pubTypes)

local function willYield(listen: pubTypes.Listen<any>, value: boolean)
   listen._canYield = value

   return listen
end

return willYield