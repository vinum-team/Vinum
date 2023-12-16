--!strict
local Vinum = require("../../src")
local Scoped = Vinum.Scoped
local Ops = Vinum.Operators
return {
	should_update_when_dependency_changes = function(_, expect)
		local scope = Scoped()
		local struct = scope:Value({
			Health = 100,
			Name = "Sinlerdev",
		})
		local HealthKey = scope:SliceOf(struct, "Health")
		Ops:Write(struct, { Health = 50, Name = "" })

		expect(Ops:Read(HealthKey)).to.equal(50)
	end,
	should_update_through_direct_writing = function(_, expect)
		local scope = Scoped()
		local struct = scope:Value({
			Health = 100,
			Name = "Sinlerdev",
		})
		local HealthKey = scope:SliceOf(struct, "Health")
		Ops:Write(HealthKey, 50)
		expect(Ops:Read(HealthKey)).to.equal(50)
		expect(Ops:Read(struct).Health).to.equal(50)
	end,
}
