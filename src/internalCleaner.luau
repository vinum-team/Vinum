local function cleaner(task: any)
    local typeOfTask = typeof(task)

    if typeOfTask == "Instance" then
        task:Destroy()
        return true
    elseif typeOfTask == "RBXScriptConnection" then
        task:Disconnect()
        return true
    elseif typeOfTask == "function" then
        task()
        return true
    elseif typeOfTask == "table" then
        if type(task.destroy) == "function" then
            task:destroy()
            return true
        elseif type(task.Destroy) == "function" then
            task:Destroy()
            return true
        else
            for _, t in task do
                return cleaner(t)
            end
            return false
        end
    end

    return false
end

return cleaner