local Vinum = require(game.ReplicatedStorage.Vinum)

return {
    ["should construct a Match object"] = function(tester)
        local expect = tester.expect
        local root = Vinum.Hold(100, Vinum.JustOk)
        local obj = Vinum.Match(root, {
            [100] = function()
                return true
            end,
            ["default"] = function()
            end
        }, Vinum.JustOk)

		expect(obj).to.be.a("table")
        expect(obj.type).to.equal("state")
        expect(obj.kind).to.equal("match")
    end,
    ["should recompute once the InputState changes"] = function(tester)
        local expect = tester.expect
        local root = Vinum.Hold(100, Vinum.JustOk)

        local flag = 0

        local obj = Vinum.Match(root, {
            [200] = function()
                flag += 1
                return true
            end,
            ["default"] = function()
            end
        }, Vinum.JustOk)

        root:set(200)
        expect(flag).to.equal(1)
    end,
    ["should recompute once a dependency changes"] = function(tester)
        local expect = tester.expect
        local root = Vinum.Hold(100, Vinum.JustOk)
        local another = Vinum.Hold(200, Vinum.JustOk)
        local obj = Vinum.Match(root, {
            [100] = function(useState)
                return useState(another) * 200
            end,
            ["default"] = function()
            end
        }, Vinum.JustOk)

		expect(obj:get()).to.equal(40000)
        another:set(1)
        expect(obj:get()).to.equal(200)

    end,
}