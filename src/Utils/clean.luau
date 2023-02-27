local function clean(task)
    local taskType = typeof(task)
    local returnType = true
    if taskType == "Instance" then
        task:Destroy()
    elseif taskType == "RBXScriptConnection" then
        task:Disconnect()
    elseif taskType == "function" then
        task()
    elseif taskType == "table" then
        local destroyMethod = task.Destroy or task.destroy 

        if destroyMethod then
            destroyMethod(task)
        else
            for _, subTask in task do
                clean(subTask)
            end
        end
    else
        returnType = false
    end

    return returnType
end

return clean