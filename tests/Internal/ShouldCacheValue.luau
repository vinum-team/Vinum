--!strict
local AddDependent = require("../../src/Internal/AddDependent")
local ShouldCacheValue = require("../../src/Internal/ShouldCacheValue")
local testkit = require("../../.lune/luneVendor/ecrTestKit")
local TEST, CASE, CHECK, FINISH = testkit.test()

local function RNode()
	return {
		value = 1,
		scope = {},
		type = "reactiveState",
	} :: any
end

TEST("Internal/ShouldCacheValue", function()
	do
		CASE("should return true if it has no dependents ")
		local root = RNode()

		CHECK(ShouldCacheValue(root) == true)
	end

	do
		CASE("should return false if it has only iListeners")
		local root = RNode()

		AddDependent(root, function() end)
		CHECK(ShouldCacheValue(root) == false)
	end

	do
		CASE("should return true if it finds a different type of dependent")
		local root = RNode()
		local a = RNode()

		AddDependent(root, a)
		AddDependent(root, function() end)
		CHECK(ShouldCacheValue(root) == true)
	end
end)

FINISH()