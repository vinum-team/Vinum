local Vinum = require(game.ReplicatedStorage.Vinum)

return {
    ["Should construct a hold object"] = function(tester)
        local expect = tester.expect

        local hold = Vinum.Hold(true, function() return true end)

        expect(hold).to.be.a("table")
        expect(hold.type).to.equal("state")
        expect(hold.kind).to.equal("hold")
    end,
    ["Should change when set()"] = function(tester)
        local expect = tester.expect

        local state = Vinum.Hold(100, function(oldValue, newValue)
            return true
        end)

        expect(state:get()).to.equal(100)
        state:set(50)
        expect(state:get()).to.equal(50)
    end,
    ["Should dismiss an update"] = function(tester)
        local expect = tester.expect

        local state = Vinum.Hold(30, function(oldValue, newValue)
            return false
        end)

        state:set(50)
        expect(state:get()).to.equal(30)
        state:set(70)
        expect(state:get()).to.equal(30)
    end

}