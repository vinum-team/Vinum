--!strict
local Package = script.Parent.Parent
local Creators = Package.Creators
local Value = require(Creators.Value)
local Ref = require(Creators.Ref)

local Operators = Package.Operators
local Write = require(Operators.Write)

-- A Stream works by using a special `send` function that 
-- ensures that the dependent that owns the channel only gets
-- the messages.
local function Stream<T>(scope, fn)
    local self = Value(scope, (0 :: any))

    self.node.dependentAdded = function(dependency, dependent)
        fn(function(value: T)
            local oldDependents = dependency.dependents
            oldDependents[dependent] = true
            dependency.dependents = {[dependent] = true}

            Write(nil, self, value)
            dependency.dependents = oldDependents
        end)
    end

    return Ref(scope, self)
end

return Stream