--!strict
local Vinum = require(game.ReplicatedStorage.Vinum)

local Hold = Vinum.Hold
local AbsorbCreator = Vinum.AbsorbCreator

local returner = function(value)
    return function()
        return value
    end
end

local constant = Hold(1, returner(true))

return {
    should_create_an_absorb = function(expect)
        local absorb = AbsorbCreator(returner(true))
        expect(absorb(constant, {}, returner(true)).meta).to.equal("Absorb")
    end,
    should_update_when_toabsorb_updates = function(expect)
        local absorbed = Hold(1, returner(true))
        local absorb = AbsorbCreator(function(self, inject)
            return inject(self._toAbsorb)
        end)

        local absorber = absorb(absorbed, {}, returner(true))

        expect(absorber:get()).to.equal(1)
    end
}