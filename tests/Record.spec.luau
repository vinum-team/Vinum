local Vinum = require(game.ReplicatedStorage.Vinum)
local read = Vinum.read
local write = Vinum.write

local function makeHold(value)
	return Vinum.Hold(value, Vinum.Processors.AlwaysTrue)
end

local function shouldBeEqual(expect, recorded, recorder)
	expect(read(recorded)).to.equal(read(recorder))
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
		local isSynced = makeHold(true)
		local recorder = Vinum.Record(recorded, isSynced)

		shouldBeEqual(expect, recorded, recorder)
		write(recorded, 10)
		shouldBeEqual(expect, recorded, recorder)

		write(isSynced, false)
		write(recorded, 4)
		expect(read(recorded)).to.never.equal(read(recorder))

	end
}
