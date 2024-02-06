--!strict
local Vinum = require("../../src")
local testkit = require("../../.lune/luneVendor/ecrTestKit")
local TEST, CASE, CHECK = testkit.test()

local Scoped = Vinum.Scoped
local Use = Vinum.Use

TEST("Operators/Use", function()
	do
		CASE("should be able to use States")
		local scope = Scoped()

		local x = scope:Source(10)
		local y = scope:Source(0)
		CHECK(Use(x.node, y) == 0)
		CHECK((y :: any).node.dependents[x.node] == true)
	end

	do
		CASE("should be able to use refStates")
		local scope = Scoped()

		local x = scope:Source(10)
		local y = scope:Source(0)
		CHECK(Use(x.node, scope:Ref(y)) == 0)
		CHECK((y :: any).node.dependents[x.node] == true)
	end
end)
