--!strict
local Vinum = require("../../src")
local Scoped = Vinum.Scoped

local Read = Vinum.Read
local Write = Vinum.Write

return {
	writes_to_normal_states = function(_, expect)
		local scope = Scoped()
		local myValue = scope:Source(100)

		Write(myValue, 200)
		expect(Read(myValue)).to.equal(200)
	end,
	writes_to_select = function(_, expect)
		local scope = Scoped()
		local myValue = scope:Source({
			health = 100,
			speed = 16,
		})
		local speedSlice = scope:Select(myValue, "speed")
		Write(speedSlice, 20)
		expect(Read(speedSlice)).to.equal(20)
		expect(Read(myValue).speed).to.equal(20)
	end,
}
