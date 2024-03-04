--!strict
local Vinum = require("../../src")
local testkit = require("../../.lune/luneVendor/ecrTestKit")
local TEST, CASE, CHECK, FINISH = testkit.test()

local Scoped = Vinum.Scoped
local Track = Vinum.Track
local Write = Vinum.Write

TEST("Operators/Track", function()
	do
		CASE("should run connection when dependency updates")
		local scope = Scoped()

		local x = scope:Source(10)
		local flag = false
		Track(x, function()
			flag = true
		end)

		Write(x, 20)
		CHECK(flag == true)
	end
end)

FINISH()
