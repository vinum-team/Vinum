local Vinum = require(game.ReplicatedStorage.Vinum)
local write = Vinum.write
local read = Vinum.read
return {
	["Dependencies should not notify destroyed state objects"] = function(tester)
		local dependency = Vinum.Hold(100, Vinum.Processors.AlwaysTrue)
		local destroyed = Vinum.Observe(dependency, Vinum.Processors.AlwaysTrue)

		local flag = 0
		destroyed:onChange(function()
			flag += 1
		end)

		Vinum.Destroy(destroyed)
		write(dependency, 23)
		tester.expect(flag).to.equal(0)
	end,
	["Dependents should be destroyed"] = function(tester)
		local dependency = Vinum.Hold(100, Vinum.Processors.AlwaysTrue)
		local dependent = Vinum.Calc(function(use)
			return use(dependency)
		end, Vinum.Processors.AlwaysTrue)

		Vinum.Destroy(dependency)
		tester
			.expect(function()
				read(dependent)
			end).to
			.throw()
	end,
	["Groups should work"] = function(tester)
		local group = Vinum.Group({
			h = 2,
		}, Vinum.Processors.AlwaysTrue)

		local gonnaBeDestroyed = Vinum.Observe(group:asState("h"))
		Vinum.Destroy(group)
		tester
			.expect(function()
				gonnaBeDestroyed:onBind(function() end)
			end).to
			.throw()

		tester
			.expect(function()
				read(group, "h")
			end).to
			.throw()
	end,
}
