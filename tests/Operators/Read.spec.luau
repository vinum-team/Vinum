--!strict
local Vinum = require("../../src")
local Scoped = Vinum.Scoped
local Read = Vinum.Read

return {
	can_work_with_states = function(_, expect)
		local scope = Scoped()
		local myValue = scope:Value(100)

		expect(Read(myValue)).to.equal(100)
	end,
	can_work_with_refs = function(_, expect)
		local scope = Scoped()
		local myValue = scope:Value(100)

		expect(Read(scope:Ref(myValue))).to.equal(100)
	end,
}
