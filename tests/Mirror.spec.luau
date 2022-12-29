local Vinum = require(game.ReplicatedStorage.Vinum)

local Mirror = Vinum.Mirror
local Hold = Vinum.Hold
local AlwaysTrue = Vinum.AlwaysTrue
local read = Vinum.read

return {
	["Should construct a Mirror object"] = function(tester)
		local expect = tester.expect
		local miObj = Mirror(Hold(true, AlwaysTrue), {
			[true] = Hold(20),
			["default"] = Hold("doesn'tExist", AlwaysTrue),
		})

		expect(miObj.type).to.equal("state")
		expect(miObj).to.be.a("table")
		expect(miObj.kind).to.equal("mirror")
	end,
	["Should change once InputState fires"] = function(tester)
		local expect = tester.expect

		local root = Hold(true, AlwaysTrue)
		local miObj = Mirror(root, {
			[true] = Hold(20),
			["default"] = Hold("doesn'tExist", AlwaysTrue),
		})

		expect(read(miObj)).to.equal(20)
		root:set(false)
		expect(read(miObj)).to.equal("doesn'tExist")
	end,
	["Should change once a Case Object changes"] = function(tester)
		local expect = tester.expect

		local root = Hold(true, AlwaysTrue)
		local trueCase = Hold(20, AlwaysTrue)
		local miObj = Mirror(root, {
			[true] = trueCase,
			["default"] = Hold("doesn'tExist", AlwaysTrue),
		})

		expect(read(miObj)).to.equal(20)
		trueCase:set(30)
		expect(read(miObj)).to.equal(30)
	end,
}
