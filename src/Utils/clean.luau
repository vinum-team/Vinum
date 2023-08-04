--!strict


--[=[
   @within Vinum

   A built-in utility for cleaning common datatypes.

   When called with:
   1. Instance: It will destroy it.
   2. RBXScriptConnection: It will disconnect it.
   3. Function: It will call it.
   4. Table: if it has a destroy/Destroy method, call it, if it doesnt, treat all the members as taskItems.
]=]
local function clean(taskItem: any)
	local taskType = typeof(task)

	-- case 1: Instance
	if taskType == "Instance" then
		taskItem:Destroy()

	-- case 2: RBXScriptConnection
	elseif taskType == "RBXScriptConnection" then
		taskItem:Disconnect()
	
        -- case 3: callback
	elseif taskType == "function" then
	    taskItem()
	
    elseif taskType == "table" then
		-- case 4: destroy() function
		if typeof(taskItem.destroy) == "function" then
			taskItem:destroy()

		-- case 5: Destroy() function
		elseif typeof(taskItem.Destroy) == "function" then
			taskItem:Destroy()

		-- case 6: array of tasks
		elseif task[1] ~= nil then
			for _, subtask in ipairs(task) do
				taskItem(subtask)
			end
		end
	end
end

return clean