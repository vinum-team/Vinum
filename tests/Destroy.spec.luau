local Vinum = require(game.ReplicatedStorage.Vinum)

return {
	["Dependencies should not notify destroyed state objects"] = function(tester)
        local dependency = Vinum.Hold(100, Vinum.AlwaysTrue)
        local destroyed = Vinum.Observe(dependency, Vinum.AlwaysTrue)

        local flag = 0
        destroyed:onChange(function()
            flag += 1
        end)

        Vinum.Destroy(destroyed)
        dependency:set(23)
        tester.expect(flag).to.equal(0)
	end,
	["Dependents should be destroyed"] = function(tester)
        local dependency = Vinum.Hold(100, Vinum.AlwaysTrue)
        local dependent = Vinum.Record(dependency, true)

        Vinum.Destroy(dependency)
        tester.expect(function()
            dependent:get()
        end).to.throw()
	end,
	["Groups should work"] = function(tester)
        local group = Vinum.Group(Vinum.AlwaysTrue)

        group:setKey("h", 2)
        local gonnaBeDestroyed = Vinum.Observe(group:asState("h"))
        Vinum.Destroy(group)
        tester.expect(function()
            gonnaBeDestroyed:onBind(function() end)
        end).to.throw()

        tester.expect(function()
           group:getKey("h")
        end).to.throw()
	end,
}
