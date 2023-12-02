--!strict

local function scoper<T>(myTable: T)
    return function(): T & {[any]: any}
        return setmetatable({}, {__index = myTable}) :: any
    end
end

return scoper