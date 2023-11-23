--!strict
local Vinum = require("../../src")

local function returner(x)
    return function()
        return x 
    end
end

return {
    should_create_a_compute = function(_, expect)
        local x  = Vinum.Compute(returner(1))
        expect(x.type).to.equal("Compute")
    end,
    should_update_when_dependency_changes = function(_, expect)
        local dep = Vinum.Value(100)
        local x = Vinum.Compute(function(Node)
            return Vinum.Use(Node, dep) / 2
        end)

        Vinum.Write(dep, 50)
        expect(Vinum.Read(x)).to.equal(25)
    end
}