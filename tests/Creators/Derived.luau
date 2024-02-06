--!strict
local Vinum = require("../../src")
local testkit = require("../../.lune/luneVendor/ecrTestKit")
local TEST, CASE, CHECK = testkit.test()

local Scoped = Vinum.Scoped
local Use = Vinum.Use
local Write = Vinum.Write
local Read = Vinum.Read
local On = Vinum.On

TEST("Creators/Derived", function()  
    do 
        CASE("should recompute everytime a dependency updates")
        local scope = Scoped()
        local x = scope:Source(10)
        -- y = 2x
        local y = scope:Derived(function(RNode)
            return Use(RNode, x) * 2
        end)

        Write(x, 20)
        CHECK(Read(y) == 40)
    end
    do 
        CASE("should release value and its cleanable CTasks when possible")
        local scope = Scoped()
        local runs = 0
        local x = scope:Source(10)
        local Derived = scope:Derived(function(RNode)
            scope:InnerScope(RNode):Add(function()
                runs += 1
            end)
            return Use(RNode, x)
        end)
        On(Derived, function()  end)
        
        Write(x, 0)
        -- NOTE: It's two runs since after Write, all of CTasks are cancelled to 
        -- prepare for a new update (state recomputation), which counts as the first 
        -- time, and then later down in the pipeline, CTasks that have the cleanable flag 
        -- get cancelled as well.
        CHECK(runs == 2)
    end
end)