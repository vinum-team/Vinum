--!strict

local function isDesTrait(value: any)
    if type(value) == "table" and value.value and value.clean then
        return true
    end

    return false
end

return isDesTrait