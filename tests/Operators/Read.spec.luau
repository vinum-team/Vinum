--!strict
local Vinum = require("../../src")

local Ops = Vinum.Operators
local Scoped = Vinum.Scoped

return {
	can_work_with_states = function(_, expect)
		local scope = Scoped()
		local myValue = scope:Value(100)

		expect(Ops:Read(myValue)).to.equal(100)
	end,
	can_work_with_refs = function(_, expect)
		local scope = Scoped()
		local myValue = scope:Value(100)

		expect(Ops:Read(scope:Ref(myValue))).to.equal(100)
	end,
}
