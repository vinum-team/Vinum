--!strict
local Vinum = require("../../src")
local testkit = require("../../.lune/luneVendor/ecrTestKit")
local TEST, CASE, CHECK = testkit.test()

local Scoped = Vinum.Scoped
local Write = Vinum.Write
local Read = Vinum.Read

TEST("Operators/Write", function()
	do
		CASE("should write data to Sources")
		local scope = Scoped()

		local x = scope:Source(10)
		CHECK(Read(x) == 10)
		Write(x, 20)
		CHECK(Read(x) == 20)
	end
end)
