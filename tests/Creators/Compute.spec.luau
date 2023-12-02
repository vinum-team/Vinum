--!strict
local Vinum = require("../../src")
local Use = Vinum.Use
local Borrowed = Vinum.Borrowed

local function returner(x)
    return function(x)
        return Vinum.Borrowed(x)
    end
end

local Scoped = Vinum.Scoped

return {
    should_create_a_compute = function(_, expect)
        local scope = Scoped()
        local x  = scope:Compute(returner(1))
        expect(x.type).to.equal("Compute")
    end,
    should_update_when_dependency_changes = function(_, expect)
        local scope = Scoped()
        local dep = scope:Value(100)
        local x = scope:Compute(function(Node)
            return Borrowed(Use(Node, dep) / 2)
        end)

        Vinum.Write(dep, 50)
        expect(Vinum.Read(x)).to.equal(25)
    end,
    should_be_destroyed = function(_, expect)
        local isDestroyed = false
        local Owned = Vinum.MakeOwned(function(value)  
            isDestroyed = true
        end)
        local scope = Scoped()
        local dep = scope:Value(100)
        scope:Compute(function(Node)
            return Owned(Use(Node, dep))
        end)

        Vinum.Kill(scope)
        expect(isDestroyed).to.equal(true)
    end
}