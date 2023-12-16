--!strict
local Vinum = require("../../src")
local Ops = Vinum.Operators
local Memos = Vinum.Memos
local Scoped = Vinum.Scoped

local function returner(x)
	return function(x)
		return Memos:Borrowed(x)
	end
end

return {
	should_create_a_compute = function(_, expect)
		local scope = Scoped()
		expect(scope:Compute(returner(true)))
	end,
	should_regenerate_when_dependency_changes = function(_, expect)
		local scope = Scoped()
		local dep = scope:Value(100)
		local computed = scope:Compute(function(Node)
			return Memos:Borrowed(Ops:Use(Node, dep) / 2)
		end)

		expect(Ops:Read(computed)).to.equal(50)
		Ops:Write(dep, 50)
		expect(Ops:Read(computed)).to.equal(25)
	end,
	should_invoke_older_trait = function(_, expect)
		local isDestroyed = false

		local scope = Scoped()
		local Owned = Memos:MakeOwned(function(value)
			isDestroyed = true
		end)
		local dep = scope:Value(100)
		scope:Compute(function(Node)
			Ops:Use(Node, dep)
			return Owned(true)
		end)

		expect(isDestroyed).to.equal(false)
		Ops:Write(dep, 200)
		expect(isDestroyed).to.equal(true)
	end,
}
