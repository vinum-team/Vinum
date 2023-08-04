--!strict
local types = require(script.Parent.Parent.types)

local function isWritable(stateObject: types.StateObj<any, any>, value: boolean)
   stateObject._writable = value

   return stateObject 
end

return isWritable