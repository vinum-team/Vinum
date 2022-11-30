local Vinum = require(game.ReplicatedStorage.Vinum)

local Mirror = Vinum.Mirror
local Hold = Vinum.Hold
local JustOk = Vinum.JustOk

return {
	["Should construct a Mirror object"] = function(tester)
		local expect = tester.expect
		local miObj = Mirror(Hold(true, JustOk), {
			[true] = Hold(20),
			["default"] = Hold("doesn'tExist", JustOk),
		})

		expect(miObj.type).to.equal("state")
		expect(miObj).to.be.a("table")
		expect(miObj.kind).to.equal("mirror")
	end,
	["Should change once InputState fires"] = function(tester)
		local expect = tester.expect

		local root = Hold(true, JustOk)
		local miObj = Mirror(root, {
			[true] = Hold(20),
			["default"] = Hold("doesn'tExist", JustOk),
		})

		expect(miObj:get()).to.equal(20)
		root:set(false)
		expect(miObj:get()).to.equal("doesn'tExist")
	end,
    ["Should change once a Case Object changes"] = function(tester)    
        local expect = tester.expect

		local root = Hold(true, JustOk)
        local trueCase = Hold(20, JustOk)
		local miObj = Mirror(root, {
			[true] = trueCase,
			["default"] = Hold("doesn'tExist", JustOk),
		})

        expect(miObj:get()).to.equal(20)
        trueCase:set(30)
        expect(miObj:get()).to.equal(30)

    end
}
