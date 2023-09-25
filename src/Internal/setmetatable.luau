--!strict

-- A proxy-function for setmetatable that has 
-- a return type of `any`

local old_setmetatable = setmetatable 

local function setmetatable(tbl: {[any]: any}, metatable: {[any]: any}): any 
    return old_setmetatable(tbl, metatable)
end

return setmetatable