local Vinum = require(game.ReplicatedStorage.Vinum)

local function makeHold(value)
	return Vinum.Hold(value, Vinum.AlwaysTrue)
end

return {
	["Should construct a Writable object"] = function(tester)
		local expect = tester.expect

		local obj = Vinum.Writable(makeHold(100))

		expect(obj).to.be.a("table")
		expect(obj.type).to.equal("state")
		expect(obj.kind).to.equal("writable")
	end,
	["Should return synced values from the owner object"] = function(tester)
		local expect = tester.expect

		local owner = makeHold(200)
		local writable = Vinum.Writable(owner)

		expect(writable:get()).to.equal(owner:get())

		writable:set(40)
		expect(owner:get()).to.equal(40)
	end,
	["Should launch updates when writing"] = function(tester)
		local expect = tester.expect

		local owner = makeHold(200)
		local writable = Vinum.Writable(owner)

		local flag = false

		Vinum.Observe(writable, Vinum.AlwaysTrue):onChange(function()
			flag = true
		end)

		writable:set(40)
		expect(flag).to.equal(true)
	end
		
}
