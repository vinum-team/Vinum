--!strict
local Vinum = require("../../src")

local Ops = Vinum.Operators
local Scoped = Vinum.Scoped

return {
	writes_to_normal_states = function(_, expect)
		local scope = Scoped()
		local myValue = scope:Value(100)

		Ops:Write(myValue, 200)
		expect(Ops:Read(myValue)).to.equal(200)
	end,
	writes_to_sliceofs = function(_, expect)
		local scope = Scoped()
		local myValue = scope:Value({
			health = 100,
			speed = 16,
		})
		local speedSlice = scope:SliceOf(myValue, "speed")
		Ops:Write(speedSlice, 20)
		expect(Ops:Read(speedSlice)).to.equal(20)
		expect(Ops:Read(myValue).speed).to.equal(20)
	end,
}
