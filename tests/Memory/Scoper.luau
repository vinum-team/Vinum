--!strict
local Scoper = require("../../src/Memory/Scoper")
local testkit = require("../../.lune/luneVendor/ecrTestKit")
local TEST, CASE, CHECK = testkit.test()

TEST("Memory/Scoper", function()
	do
		CASE("should create a scope creator function")
		local flag = false
		local scoped = Scoper({
			Add = function(self)
				flag = true
			end,
		})

		scoped():Add()
		CHECK(flag == true)
	end
end)
