--!strict
local Vinum = require("../../src")
local Scoped = Vinum.Scoped

local Read = Vinum.Read
local Write = Vinum.Write

return {
	should_update_when_dependency_changes = function(_, expect)
		local scope = Scoped()
		local struct = scope:Value({
			Health = 100,
			Name = "Sinlerdev",
		})
		local HealthKey = scope:SliceOf(struct, "Health")
		Write(struct, { Health = 50, Name = "" })

		expect(Read(HealthKey)).to.equal(50)
	end,
	should_update_through_direct_writing = function(_, expect)
		local scope = Scoped()
		local struct = scope:Value({
			Health = 100,
			Name = "Sinlerdev",
		})
		local HealthKey = scope:SliceOf(struct, "Health")
		Write(HealthKey, 50)
		expect(Read(HealthKey)).to.equal(50)
		expect(Read(struct).Health).to.equal(50)
	end,
}
