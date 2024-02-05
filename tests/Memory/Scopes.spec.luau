--!strict
local Scoper = require("../../src/Memory/Scoper")
local Kill = require("../../src/Memory/Kill")
local DerivedScope = require("../../src/Memory/DerivedScope")

local Vinum = require("../../src")
local Scoped = Vinum.Scoped
return {
	should_create_a_scope = function(_, expect)
		local myScope = Scoper({})()
		expect(type(myScope :: any)).to.be.equal("table")
	end,
	should_create_a_derived_scope = function(_, expect)
		local flag = false
		local ogScope = Scoper({
			Add = function(self)
				flag = not flag
			end,
		})()

		local derivedScope = DerivedScope(ogScope)

		derivedScope:Add()
		expect(flag).to.equal(true)
	end,
	should_kill_a_scope_of_functions = function(_, expect)
		local ogScope = Scoper({
			fn = function(self, fn)
				table.insert(self, fn)
			end,
		})()

		local flags = 0

		for i = 1, 3 do
			ogScope:fn(function()
				flags += 1
			end)
		end

		Kill(ogScope)

		expect(flags).to.equal(3)
		expect((ogScope :: any)[1]).to.never.be.ok()
		expect((ogScope :: any)[2]).to.never.be.ok()
		expect((ogScope :: any)[3]).to.never.be.ok()
	end,
	should_kill_a_scope_of_state_structs = function(_, expect)
		local vScope = Scoped()

		vScope:Ref(vScope:Source(10))

		expect((vScope :: any)[1].type).to.equal("Source")

		Kill(vScope)

		expect((vScope :: any)[1]).to.be.never.ok()
		expect((vScope :: any)[2]).to.be.never.ok()
	end,
}
