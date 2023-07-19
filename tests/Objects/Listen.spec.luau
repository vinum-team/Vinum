local Vinum = require(game.ReplicatedStorage.Vinum)

local Hold = Vinum.Hold
local Listen = Vinum.Listen
local Compute = Vinum.Compute

local returner = function(value)
    return function()
        return value
    end
end
return {
    should_create_a_listener = function(expect)
        local dep = Hold(true, returner(true))
        local listener = Listen(dep, returner(true))
        expect(listener.meta).to.equal("Listen")
    end,
    should_run_connections = function(expect)
        local dep = Hold(true, returner(true))
        local listener = Listen(dep, returner(true))

        local didRun = false
        listener:Connect(function()
            didRun = true
        end)

        dep:set(false)
        expect(didRun).to.equal(true)
    end,
    should_have_the_old_and_new_values = function(expect)
        local dep = Hold(true, returner(true))
        local listener = Listen(dep, returner(true))
        local old, new
        listener:Connect(function(o, n)
            old = o
            new = n
        end)

        dep:set(false)
        expect(old).to.equal(true)
        expect(new).to.equal(false)
    end,
    should_capture_the_old_and_new_values_in_itself = function(expect)
        local dep = Hold(true, returner(true))
        local listener = Listen(dep, returner(true))

        dep:set(false)
        local valueSet = listener:get()
        expect(valueSet.old).to.equal(true)
        expect(valueSet.new).to.equal(false)
    end,
    should_have_dependents = function(expect)
        local dep = Hold(true, returner(true))
        local listener = Listen(dep, returner(true))

        local computer = Compute(function(use)
            local valueSet = use(listener)

            return {valueSet.old, valueSet.new}
        end, returner(true))

        dep:set(false)
        expect(computer:get()[1]).to.equal(true)
        expect(computer:get()[2]).to.equal(false)
    end
        
}