--!strict
local Vinum = require("../../src")

local Ops = Vinum.Operators
local Scoped = Vinum.Scoped
return {
	works_with_normal_states = function(_, expect)
		local scope = Scoped()
		local myValue = scope:Value(100)
		local ran = false

		Ops:On(myValue, function()
			ran = true
		end)

		Ops:Write(myValue, 200)

		expect(ran).to.equal(true)
	end,
	can_connect_more_than_one_connection = function(_, expect)
		local scope = Scoped()
		local myValue = scope:Value(100)

		local runs = 0
		for i = 1, 2, 1 do
			Ops:On(myValue, function()
				runs += 1
			end)
		end

		Ops:Write(myValue, 200)
		expect(runs).to.equal(2)
	end,
	can_unwrap_refs = function(_, expect)
		local scope = Scoped()
		local myValue = scope:Value(100)
		local Ref = scope:Ref(myValue)

		local ran = false

		Ops:On(Ref, function()
			ran = true
		end)

		Ops:Write(myValue, 200)
		expect(ran).to.equal(true)
	end,
}
