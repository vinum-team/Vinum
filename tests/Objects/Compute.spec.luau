--!strict
local Vinum = require("../../src")
local task = require("@lune/task")

local Hold = Vinum.Hold
local Compute = Vinum.Compute

local async = Vinum.async
local returner = function(value)
	return function()
		return value
	end
end

return {
	should_create_a_compute = function(skip, expect)
		expect(Compute(function()
			return 1
		end, returner(true)).meta).to.equal("Compute")
	end,
	should_inject_dependencies = function(skip, expect)
		local dependency = Hold(100, returner(true))
		local computed = Compute(function(inject)
			return inject(dependency)
		end, returner(true))

		dependency:set(200)
		expect(computed:get()).to.equal(200)
	end,
	should_simplify_tree = function(skip, expect)
		local sharedDependency = Hold(100, returner(true))
		local firstDependency = Compute(function(use)
			return use(sharedDependency)
		end, returner(true))

		local secondDependency = Compute(function(use)
			return use(firstDependency)
		end, returner(true))

		local times = -1
		Compute(function(use)
			times += 1
			return use(secondDependency) + use(sharedDependency)
		end, returner(true))

		sharedDependency:set(200)
		expect(times).to.equal(1)
	end,
	shouldnt_allow_updates_given_disallowing_processor = function(skip, expect)
		local dependency = Hold(100, returner(true))
		local computed = Compute(function(inject)
			return inject(dependency)
		end, returner(false))

		dependency:set(200)
		expect(computed:get()).to.never.equal(200)
	end,
	should_cancel_async_operations = function(skip, expect)
		local first_flag = 0
		local second_flag = 0
		local dependency = Hold(false, returner(true))

		Compute(function(use, addAsync)
			addAsync(async(function()
				first_flag += 1
				task.wait(2)
				second_flag += 1
			end))
			return use(dependency)
		end, returner(true))

		dependency:set(true)

		task.wait(2)
		expect(first_flag).to.equal(2)
		expect(second_flag).to.equal(1)
	end,
}
