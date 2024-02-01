--!strict

local Package = script.Parent.Parent
local types = require(Package.types)
local Memory = Package.Memory
local Kill = require(Memory.Kill)
local DerivedScope = require(Memory.DerivedScope)
local function InnerScope<T, U>(scope: types.Scope<T>, Node: types.RNode, additionalConstructors: U?): types.Scope<T & U>
    local myScope = DerivedScope(scope)

    table.insert(Node.cancelableTasks, {
        cancel = function()
            Kill(myScope)
        end
    })

    return myScope
end

return InnerScope