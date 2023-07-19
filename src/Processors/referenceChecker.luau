return function(old, new, isdestroying)
    if not isdestroying then
        if type(old) == "table" then
            return true
        end

        return old ~= new
    end

    return true
end