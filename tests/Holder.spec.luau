local Vinum = require(game.ReplicatedStorage.Vinum)

return {
    ["Should change when set()"] = function(tester)
        local expect = tester.expect

        local state = Vinum.Holder(100, function(oldValue, newValue)
            return true
        end)

        expect(state:get()).to.equal(100)
        state:set(50)
        expect(state:get()).to.equal(50)
    end,
    ["Should drop an update"] = function(tester)
        local expect = tester.expect

        local state = Vinum.Holder(30, function(oldValue, newValue)
            return false
        end)

        state:set(50)
        expect(state:get()).to.equal(30)
        state:set(70)
        expect(state:get()).to.equal(30)
    end

}