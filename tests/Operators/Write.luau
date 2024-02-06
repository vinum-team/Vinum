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

	do
		CASE("should write data to Selects")
		local scope = Scoped()
		local x = scope:Source({
			hi = 10,
		})

		local x_ = scope:Select(x, "hi")

		Write(x_, 20)
		CHECK(Read(x_) == Read(x).hi)
		CHECK(Read(x_) == 20)
	end
end)
