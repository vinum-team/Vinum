local Vinum = require(game.ReplicatedStorage.Vinum)

return {
    ["Should create a Group object"] = function(tester)
        local expect = tester.expect

        local obj = Vinum.Group(Vinum.JustOk)

        expect(obj).to.be.a("table")
        expect(obj.kind).to.equal("group")
        expect(obj.type).to.equal("state")
    end,
    ["Should change"] = function(tester)
        local expect = tester.expect

        local obj = Vinum.Group(Vinum.JustOk)

        obj:setKey("hi", 12)
        expect(obj:getKey("hi")).to.equal(12)
    end,
    ["should dismiss an update"] = function(tester)
        local expect = tester.expect

        local obj = Vinum.Group(function() return false end)

        obj:setKey("hi", false)
        expect(obj:getKey("hi")).to.be.a("nil")
    end
}