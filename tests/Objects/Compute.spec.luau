--!strict
local Vinum = require(game.ReplicatedStorage.Vinum)

local Hold = Vinum.Hold
local Compute = Vinum.Compute

local returner = function(value)
    return function()
        return value
    end
end

return {
    should_create_a_compute = function(expect)
        expect(Compute(function() return 1 end, returner(true)).meta).to.equal("Compute")
    end,
    should_inject_dependencies = function(expect)
        local dependency = Hold(100, returner(true))
        local computed = Compute(function(inject)
            return inject(dependency)
        end, returner(true))
        
        dependency:set(200)
        expect(computed:get()).to.equal(200)
    end,
    shouldnt_allow_updates_given_disallowing_processor = function(expect)
        local dependency = Hold(100, returner(true))
        local computed = Compute(function(inject)
            return inject(dependency)
        end, returner(false))

        dependency:set(200)
        expect(computed:get()).to.never.equal(200)
    end
}