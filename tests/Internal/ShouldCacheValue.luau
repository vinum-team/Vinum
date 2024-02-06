--!strict
local RNode = require("../../src/Internal/RNode")
local AddDependent = require("../../src/Internal/AddDependent")
local ShouldCacheValue = require("../../src/Internal/ShouldCacheValue")
local testkit = require("../../.lune/luneVendor/ecrTestKit")
local TEST, CASE, CHECK = testkit.test()

TEST("Internal/ShouldCacheValue", function()
	local function iListenerOwner()
		return {
			type = "iListener",
			onUpdate = function() end,
		}
	end
	do
		CASE("should return true if it has no dependents ")
		local root = RNode({})

		CHECK(ShouldCacheValue(root) == true)
	end

	do
		CASE("should return false if it has only iListeners")
		local root = RNode({})
		local a = RNode(iListenerOwner())

		AddDependent(root, a)
		CHECK(ShouldCacheValue(root) == false)
	end

	do
		CASE("should return true if it finds a different type of dependent")
		local root = RNode({})
		local a = RNode({})
		local b = RNode(iListenerOwner())

		AddDependent(root, a)
		AddDependent(root, b)
		CHECK(ShouldCacheValue(root) == true)
	end
end)
