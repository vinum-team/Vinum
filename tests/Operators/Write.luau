--!strict
local Vinum = require("../../src")
local testkit = require("../../.lune/luneVendor/ecrTestKit")
local TEST, CASE, CHECK, FINISH = testkit.test()

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
		CASE("should write data to Deriveds")
		local scope = Scoped()

		local x = scope:Derived(function(self)
			return 1 
		end)

		Write(x, 10)
		CHECK(Read(x) == 10)
	end
end)

FINISH()