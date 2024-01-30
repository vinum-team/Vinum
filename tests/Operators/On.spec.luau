--!strict
local Vinum = require("../../src")
local Scoped = Vinum.Scoped

local On = Vinum.On
local Write = Vinum.Write

return {
	works_with_normal_states = function(_, expect)
		local scope = Scoped()
		local myValue = scope:Value(100)
		local ran = true
		On(myValue, function()
			ran = not ran
		end)

		Write(myValue, 200)
		Write(myValue, 200)

		expect(ran).to.equal(true)
	end,
	can_connect_more_than_one_connection = function(_, expect)
		local scope = Scoped()
		local myValue = scope:Value(100)

		local runs = 0
		for i = 1, 2, 1 do
			On(myValue, function()
				runs += 1
			end)
		end

		Write(myValue, 200)
		expect(runs).to.equal(2)
	end,
	can_unwrap_refs = function(_, expect)
		local scope = Scoped()
		local myValue = scope:Value(100)
		local Ref = scope:Ref(myValue)

		local ran = false

		On(Ref, function()
			ran = true
		end)

		Write(myValue, 200)
		expect(ran).to.equal(true)
	end,
}
