--!strict
local Vinum = require("../../src")

local Scoped = Vinum.Scoped
local Use = Vinum.Use
local Read = Vinum.Read
local Write = Vinum.Write
local On = Vinum.On

local function returner(x)
	return function(x)
		return x
	end
end

return {
	should_create_a_derived = function(_, expect)
		local scope = Scoped()
		expect(scope:Derived(returner(true)))
	end,
	should_regenerate_when_dependency_changes = function(_, expect)
		local scope = Scoped()
		local dep = scope:Source(100)
		local computed = scope:Derived(function(Node)
			return Use(Node, dep) / 2
		end)

		expect(Read(computed)).to.equal(50)
		Write(dep, 50)
		expect(Read(computed)).to.equal(25)
	end,
	should_clean_up_older_scope = function(_, expect)
		local scope = Scoped()
		local dep = scope:Source(100)
		local destructed = false
		
		scope:Derived(function(Node)
			Use(Node, dep)
			return scope:InnerScope(Node):Add(function()
				destructed = true
			end)
		end)

		expect(destructed).to.equal(false)
		Write(dep, 50)
		expect(destructed).to.equal(true)
	end,
	should_clean_up_scope_when_dismissed = function(_, expect)
		local scope = Scoped()
		local dep = scope:Source(100)
		local destructed = 0
		
		local t = scope:Derived(function(Node)
			Use(Node, dep)
			return scope:InnerScope(Node):Add(function()
				destructed += 1
			end)
		end)

		On(t, returner :: any)
		Write(dep, 50)
		expect(destructed).to.equal(2)
	end
}
