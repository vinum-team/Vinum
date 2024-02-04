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
	should_create_a_compute = function(_, expect)
		local scope = Scoped()
		expect(scope:Compute(returner(true)))
	end,
	should_regenerate_when_dependency_changes = function(_, expect)
		local scope = Scoped()
		local dep = scope:Value(100)
		local computed = scope:Compute(function(Node)
			return Use(Node, dep) / 2
		end)

		expect(Read(computed)).to.equal(50)
		Write(dep, 50)
		expect(Read(computed)).to.equal(25)
	end,
	should_clean_up_older_scope = function(_, expect)
		local scope = Scoped()
		local dep = scope:Value(100)
		local destructed = false
		
		scope:Compute(function(Node)
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
		local dep = scope:Value(100)
		local destructed = 0
		
		local t = scope:Compute(function(Node)
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
