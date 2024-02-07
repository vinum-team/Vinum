--!strict
local Scoper = require("../../src/Memory/Scoper")
local DerivedScope = require("../../src/Memory/DerivedScope")
local testkit = require("../../.lune/luneVendor/ecrTestKit")
local TEST, CASE, CHECK = testkit.test()

TEST("Memory/DerivedScope", function()
	do
		CASE("should inherit the constructors of the scope")
		local flag = false
		local myScope = Scoper({
			add = function(self)
				flag = true
			end,
		})()
		local dScope = DerivedScope(myScope, {
			hi = function(self)
				flag = false
			end
		})

		dScope:add()
		CHECK(flag == true)
		dScope:hi()
		CHECK(flag == false)
	end

	do
		CASE("should merge additional constructors")
		local myScope = Scoper({
			add = function(self)
				return true
			end,
		})()
		local derivedScope = DerivedScope(myScope, {
			subtract = function(self)
				return false
			end,
		})

		CHECK(derivedScope:subtract() == false)
	end
end)
