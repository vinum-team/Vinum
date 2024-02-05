--!strict
local Vinum = require("../../src")
local Scoped = Vinum.Scoped

local Use = Vinum.Use
local Batch = Vinum.Batch
local Read = Vinum.Read

return {
	should_batch_updates = function(_, expect)
		local scope = Scoped()

		local root_1 = scope:Source(1)
		local root_2 = scope:Source(2)

		local updated = 0
		local dep = scope:Derived(function(RNode)
			updated += 1
			return Use(RNode, root_1) + Use(RNode, root_2)
		end)

		Batch(root_1, 2, root_2, 4)

		expect(updated).to.equal(2)
		expect(Read(dep)).to.equal(6)
	end,
}
