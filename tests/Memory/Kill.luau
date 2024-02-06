--!strict
local Vinum = require("../../src")
local AddCTask = require("../../src/Internal/AddCTask")
local testkit = require("../../.lune/luneVendor/ecrTestKit")
local TEST, CASE, CHECK = testkit.test()

local Scoped = Vinum.Scoped
local Kill = Vinum.Kill
local Use = Vinum.Use

TEST("Memory/Kill", function()
	do
		CASE("should run any functions stored in the scope")
		local scope = Scoped()

		local flag = false
		scope:Add(function()
			flag = true
		end)

		CHECK(flag == false)
		Kill(scope)
		CHECK(flag == true)
	end

	do
		CASE("should cleanup the value and CTasks of the state struct")
		local scope = Scoped()

		local x = scope:Source(10)
		local flag = false
		AddCTask(x.node, {
			cancel = function(self)
				flag = true
			end,
		})

		Kill(scope)
		CHECK(x.value == nil)
		CHECK(x.node.cancelableTasks == nil)
		CHECK(flag == true)
	end
	do
		CASE("should cleanup the scope of dependent state structs")
		local firstScope = Scoped()
		local secondScope = Scoped()

		local x = firstScope:Source(10)
		local y = secondScope:Derived(function(Node)
			return Use(Node, x)
		end)

		Kill(firstScope)
		CHECK(y.value == nil)
	end
end)
