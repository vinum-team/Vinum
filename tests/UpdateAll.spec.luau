--!strict
local UpdateAll = require("../src/Internal/UpdateAll")
local RNode = require("../src/Internal/RNode")
local AddDependent = require("../src/Internal/AddDependent")

local Owner = function(name, tracker)
    return {
        onUpdate = function(self)
            table.insert(tracker, name)
        end,
        name = name
    }
end

return {
	should_update = function(_, expect)
        local tracker = {}
        local root = RNode(Owner("root", tracker))
        local a = RNode(Owner("a", tracker))
        AddDependent(root, a)

        UpdateAll(false,  1, root)

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
    end
    

}
