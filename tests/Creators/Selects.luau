--!strict
local Vinum = require("../../src")
local testkit = require("../../.lune/luneVendor/ecrTestKit")
local TEST, CASE, CHECK = testkit.test()

local Scoped = Vinum.Scoped
local Write = Vinum.Write
local Read = Vinum.Read

TEST("Creators/Selects", function()
	do
		CASE("should adhere to the owner's value")
		local scope = Scoped()
        local x = scope:Source({
            hi = 10
        })

        CHECK(Read(scope:Select(x, "hi")) == 10)
	end

    do 
        CASE("should update whenever the owner changes")
        local scope = Scoped()
        local x = scope:Source({
            hi = 10
        })
        local hi = scope:Select(x, "hi")
        Write(x, {hi = 20})
        CHECK(Read(hi) == 20)
    end
end)
