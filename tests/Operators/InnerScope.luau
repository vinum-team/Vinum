--!strict
local Vinum = require("../../src")
local testkit = require("../../.lune/luneVendor/ecrTestKit")
local TEST, CASE, CHECK = testkit.test()

local Scoped = Vinum.Scoped

TEST("Operators/InnerScope", function() 
    do 
        CASE("should add a CTask with a cleanable field to X")
        local scope = Scoped()
        local source = scope:Source(10)

        scope:InnerScope(source.node)
        CHECK(((source.node.cancelableTasks)::any)[1].cleanable == true)
    end
end)