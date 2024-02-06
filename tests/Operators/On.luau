--!strict
local Vinum = require("../../src")
local testkit = require("../../.lune/luneVendor/ecrTestKit")
local TEST, CASE, CHECK = testkit.test()

local Scoped = Vinum.Scoped
local On = Vinum.On
local Write = Vinum.Write

TEST("Operators/On", function()
	do
		CASE("should run connection when dependency updates")
		local scope = Scoped()

		local x = scope:Source(10)
		local flag = false
		On(x, function()
			flag = true
		end)

		Write(x, 20)
		CHECK(flag == true)
	end
end)
