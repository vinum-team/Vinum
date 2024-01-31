--!strict
local Vinum = require("../../src")

local Scoped = Vinum.Scoped
local Use = Vinum.Use
local Read = Vinum.Read
local Write = Vinum.Write


local MakeOwned = Vinum.MakeOwned
local Borrowed = Vinum.Borrowed

local function returner(x)
	return function(x)
		return Borrowed(x)
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
			return Borrowed(Use(Node, dep) / 2)
		end)

		expect(Read(computed)).to.equal(50)
		Write(dep, 50)
		expect(Read(computed)).to.equal(25)
	end,
	should_invoke_older_trait = function(_, expect)
		local isDestroyed = false

		local scope = Scoped()
		local Owned = MakeOwned(function(value)
			isDestroyed = true
		end)
		local dep = scope:Value(100)
		scope:Compute(function(Node)
			Use(Node, dep)
			return Owned(true)
		end)

		expect(isDestroyed).to.equal(false)
		Write(dep, 200)
		expect(isDestroyed).to.equal(true)
	end,
}
