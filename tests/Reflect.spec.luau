local Vinum = require(game.ReplicatedStorage.Vinum)

local function makeHold(value)
	return Vinum.Hold(value, Vinum.AlwaysTrue)
end

return {
	["Should construct a Reflect object"] = function(tester)
		local expect = tester.expect

		local obj = Vinum.Reflect(makeHold(100))

		expect(obj).to.be.a("table")
		expect(obj.type).to.equal("state")
		expect(obj.kind).to.equal("reflect")
	end,
	["Should return synced values from the Reflected"] = function(tester)
		local expect = tester.expect

		local reflected = makeHold(200)
		local reflector = Vinum.Reflect(reflected)

		expect(reflected:get()).to.equal(reflector:get())

		reflected:set(10)
		expect(reflected:get()).to.equal(reflector:get())
	end,
}
