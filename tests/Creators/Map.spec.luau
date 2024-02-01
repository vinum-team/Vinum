--!strict
local Vinum = require("../../src")
local Scoped = Vinum.Scoped

local Read = Vinum.Read
local Write = Vinum.Write

return {
	should_update_when_the_mapped_state_changes = function(_, expect)
		local scope = Scoped()
		local mapped = scope:Value(100)
		local mapper = scope:Map(mapped, {
			[100] = 100,
			["default"] = 0,
		})

		Write(mapped, 0)
		expect(Read(mapper)).to.equal(0)
	end,
	should_support_states = function(_, expect)
		local scope = Scoped()
		local mapped = scope:Value(0)
		local dep = scope:Value(20)
		local mapper = scope:Map(mapped, {
			[100] = 100,
			["default"] = dep,
		})

		Write(dep, 100)
		expect(Read(mapper)).to.equal(100)
	end,
}
