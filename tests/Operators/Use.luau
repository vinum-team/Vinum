--!strict
local Vinum = require("../../src")
local testkit = require("../../.lune/luneVendor/ecrTestKit")
local TEST, CASE, CHECK, FINISH = testkit.test()

local Scoped = Vinum.Scoped
local Use = Vinum.Use

TEST("Operators/Use", function()
	do
		CASE("should be able to use States")
		local scope = Scoped()

		local x = scope:Source(10)
		local y = scope:Source(0)
		CHECK(Use(x, y) == 0)
		CHECK((y :: any).dependents[x] == true)
	end

	do
		CASE("should be able to use refStates")
		local scope = Scoped()

		local x = scope:Source(10)
		local y = scope:Source(0)
		CHECK(Use(x, scope:Ref(y)) == 0)
		CHECK((y :: any).dependents[x] == true)
	end
end)

FINISH()