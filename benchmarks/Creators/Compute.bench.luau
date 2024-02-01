--!strict
local Vinum = require("../../src")
local testkit = require("../../.lune/luneVendor/ecrTestKit")
local BENCH, START = testkit.benchmark()
local function TITLE(name: string)
    print()
    print(testkit.color.white(name))
end

local Scope = Vinum.Scoped()

do TITLE "Compute" 
    BENCH("Creating Computes", function()  
        for i = 1, START(20_000) do
            Scope:Compute(function(RNode)  
                return 1
            end)
        end
    end)

    BENCH("Updating Computes", function()  
        local v = Scope:Compute(function(RNode)  
                return 1
        end)

        for i = 1, START(20_000) do
            v.onUpdate(v)
        end
    end)
end