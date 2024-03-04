--!strict
local task = require("@lune/task")
local Vinum = require("../../src")
local testkit = require("../../.lune/luneVendor/ecrTestKit")
local TEST, CASE, CHECK, FINISH = testkit.test()

local Scoped = Vinum.Scoped
local Async = Vinum.Async

TEST("Operators/Async", function()
	do
		CASE("should manage the async operation")
		local scope = Scoped()

		local ran = 0
		scope:Derived(function(self)
			Async(self, function()
				task.wait(2)
				ran += 1
			end)

			return 0
		end)
		CHECK(ran == 0)
		task.wait(2)
		CHECK(ran == 1)
	end

	do
		CASE("should cancel async operations")

		local scope = Scoped()

		local x = scope:Source(10)
		local first_flag = false
		local second_flag = false
		scope:Derived(function(self)
			Async(self, function()
				first_flag = not first_flag
				task.wait(1)
				second_flag = not second_flag
			end)
			return Vinum.Use(self, x)
		end)
		CHECK(first_flag == true)
		CHECK(second_flag == false)
		Vinum.Write(x, 20)
		CHECK(first_flag == false)
		CHECK(second_flag == false)

		task.wait(1)
		CHECK(second_flag == true)
	end
end)

FINISH()
