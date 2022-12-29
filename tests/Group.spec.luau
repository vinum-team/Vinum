local Vinum = require(game.ReplicatedStorage.Vinum)
local read = Vinum.read

return {
	["Should create a Group object"] = function(tester)
		local expect = tester.expect

		local obj = Vinum.Group({}, Vinum.AlwaysTrue)

		expect(obj).to.be.a("table")
		expect(obj.kind).to.equal("group")
		expect(obj.type).to.equal("state")
	end,
	["Should change"] = function(tester)
		local expect = tester.expect

		local obj = Vinum.Group({}, Vinum.AlwaysTrue)

		obj:setKey("hi", 12)
		expect(read(obj, "hi")).to.equal(12)
	end,
	["should dismiss an update"] = function(tester)
		local expect = tester.expect

		local obj = Vinum.Group({}, function()
			return false
		end)

		obj:setKey("hi", false)
		expect(read(obj, "hi")).to.be.a("nil")
	end,
	["Should be able to transform Keys into emulated Self-Containing States"] = function(tester)
		local expect = tester.expect

		local obj = Vinum.Group({
			hi = 123,
		}, Vinum.AlwaysTrue)

		local selfObj = obj:asState("hi")

		expect(read(selfObj)).to.equal(read(obj, "hi"))
	end,
}
