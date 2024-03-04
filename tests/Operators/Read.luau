--!strict
local Vinum = require("../../src")
local testkit = require("../../.lune/luneVendor/ecrTestKit")
local TEST, CASE, CHECK, FINISH = testkit.test()

local Scoped = Vinum.Scoped
local Read = Vinum.Read

TEST("Operators/Read", function()
	do
		CASE("should read data.")
		local scope = Scoped()

		local x = scope:Source(10)

		CHECK(Read(x) == 10)
	end
end)

FINISH()
