local Vinum = require(game.ReplicatedStorage.Vinum)

return {
	["Should construct a observe object"] = function(tester)
		local expect = tester.expect

		local holdState = Vinum.Hold(true, Vinum.AlwaysTrue)
		local observeState = Vinum.Observe(holdState, function(newValue)
			return true
		end)

		expect(observeState).to.be.a("table")
		expect(observeState.type).to.equal("state")
		expect(observeState.kind).to.equal("observe")
	end,
	["Should fire all connections with valid arguments"] = function(tester)
		local expect = tester.expect

		local holdState = Vinum.Hold(true, Vinum.AlwaysTrue)
		local observeState = Vinum.Observe(holdState, function(newValue)
			return true
		end)

		local flags = 0
		local newValue
		observeState:onChange(function(x)
			flags += 1
			newValue = x
		end)

		holdState:set(false)
		expect(newValue).to.equal(false)
		expect(flags).to.equal(1)
	end,
	["Should dismiss updates"] = function(tester)
		local expect = tester.expect

		local holdState = Vinum.Hold(true, Vinum.AlwaysTrue)
		local observeState = Vinum.Observe(holdState, function(newValue)
			return false
		end)

		local flags = 0

		observeState:onChange(function()
            flags += 1
        end)

        expect(flags).to.equal(0)
	end,
	["Should be yield-safe"] = function(tester)
		local expect = tester.expect

		local holdState = Vinum.Hold(true, Vinum.AlwaysTrue)
		local observeState = Vinum.Observe(holdState, function(newValue)
			return true
		end)
		
		local firstConnectionFlag = false
		observeState:onChange(function()
			task.wait(3)
			firstConnectionFlag = true
		end)

		local secondConnectionFlag = false
		observeState:onChange(function()
			secondConnectionFlag = true
		end)

		holdState:set(123)
		expect(secondConnectionFlag).to.equal(true)
		task.wait(4)
		expect(firstConnectionFlag).to.equal(true)
	end
}
