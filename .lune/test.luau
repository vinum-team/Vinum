local task = require("@lune/task")
local function runInCo(fn, time)
    local co = coroutine.wrap(fn)
    return co(time)
end

local tab = {
    hi = {
        sup = true
    }
}

local fn = function()
    tab.hi.sup = false
end

local x, y = runInCo(function(become)
    print("hi")
    task.wait(1)
    print(become)
    become()
end, fn)

print("sup")

task.wait(1)

print(tab)