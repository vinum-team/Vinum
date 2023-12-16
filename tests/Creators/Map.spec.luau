--!strict
local Vinum = require("../../src")
local Ops = Vinum.Operators
local Memos = Vinum.Memos
local Scoped = Vinum.Scoped

return {
	should_update_when_the_mapped_state_changes = function(_, expect)
		local scope = Scoped()
		local mapped = scope:Value(100)
		local mapper = scope:Map(mapped, {
			[100] = Memos:Borrowed(100),
			["default"] = Memos:Borrowed(0),
		})

		Ops:Write(mapped, 0)
		expect(Ops:Read(mapper)).to.equal(0)
	end,
	should_support_states = function(_, expect)
		local scope = Scoped()
		local mapped = scope:Value(0)
		local dep = scope:Value(20)
		local mapper = scope:Map(mapped, {
			[100] = Memos:Borrowed(100),
			["default"] = dep,
		})

		Ops:Write(dep, 100)
		expect(Ops:Read(mapper)).to.equal(100)
	end,
}
