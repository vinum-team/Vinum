--!strict
local UpdateAll = require("../src/Internal/UpdateAll")
local RNode = require("../src/Internal/RNode")
local AddDependent = require("../src/Internal/AddDependent")

local Owner = function(name, tracker)
	return {
		onUpdate = function(self)
			table.insert(tracker, name)
		end,
		name = name,
	}
end

return {
	should_update = function(_, expect)
		local tracker = {}
		local root = RNode(Owner("root", tracker))
		local a = RNode(Owner("a", tracker))
		AddDependent(root, a)

		UpdateAll(false, 1, root)

		expect(tracker[1]).to.equal("root")
		expect(tracker[2]).to.equal("a")
	end,
	should_work_with_triangle_case = function(_, expect)
		local tracker = {}
		local a = RNode(Owner("A", tracker))
		local b = RNode(Owner("B", tracker))
		local c = RNode(Owner("C", tracker))

		AddDependent(a, b)
		AddDependent(a, c)
		AddDependent(b, c)
		UpdateAll(false, 1, a)

		expect(tracker[1]).to.equal("A")
		expect(tracker[2]).to.equal("B")
		expect(tracker[3]).to.equal("C")
	end,
	should_work_sort_dependencies_before_dependents = function(_, expect)
		local tracker = {}
		local root = RNode(Owner("root", tracker))
		local dep_level1_1 = RNode(Owner("dep_level1_1", tracker))
		local dep_level1_2 = RNode(Owner("dep_level1_2", tracker))
		local dep_level2_1 = RNode(Owner("dep_level2_1", tracker))

		AddDependent(root, dep_level1_1)
		AddDependent(root, dep_level1_2)
		AddDependent(dep_level1_1,dep_level2_1 )
		AddDependent(dep_level1_2,dep_level2_1 )
		UpdateAll(false, 1, root)
		expect(tracker[1]).to.equal("root")
		expect(tracker[2]).to.equal("dep_level1_1")
		expect(tracker[3]).to.equal("dep_level1_2")
		expect(tracker[4]).to.equal("dep_level2_1")
	end
}
