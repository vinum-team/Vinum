local Vinum = require(game.ReplicatedStorage.Vinum)

local function makeHold(value)
	return Vinum.Hold(value, Vinum.AlwaysTrue)
end

return {
	["Should construct a Record Object"] = function(tester)
		local expect = tester.expect

		local obj = Vinum.Record(makeHold(200), true)
		expect(obj).to.be.a("table")
		expect(obj.type).to.equal("state")
		expect(obj.kind).to.equal("record")
	end,
	["Should listen to updates while being synced, while otherwise when desynced"] = function(tester)
		local expect = tester.expect
		local recorded = makeHold(200)
		local recorder = Vinum.Record(recorded, true)

		expect(recorder:get()).to.equal(recorded:get())
		recorded:set(4)
		expect(recorder:get()).to.equal(recorded:get())

		recorder:desync()
		recorded:set(5)
		expect(recorder:get()).to.never.equal(recorded:get())
	end,
	["Should resync"] = function(tester)
		local expect = tester.expect
		local recorded = makeHold(200)
		local recorder = Vinum.Record(recorded, false)

		local flag = 0
		local newValuex = 0
		Vinum.Observe(recorder, Vinum.AlwaysTrue):onChange(function(newValue)
			flag += 1
			newValuex = newValue
		end)
		recorded:set(50)
		expect(flag).to.equal(0)
		expect(newValuex).to.equal(0)
		recorder:sync()
		recorder:desync()
		expect(flag).to.equal(1)
		expect(newValuex).to.equal(50)
	end,
}
