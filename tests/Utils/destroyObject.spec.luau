local Vinum = require(game.ReplicatedStorage.Vinum)

local Hold = Vinum.Hold
local Compute = Vinum.Compute
local destroyObject = Vinum.destroyObject
local graph = Vinum.graph

local returner = function(value)
	return function()
		return value
	end
end

return {
	should_disconnect_all_relations_with_dependencies = function(expect)
		local dep = Hold(100, returner(true))
		local object = Compute(function(use)
			return use(dep)
		end, returner(true))

		destroyObject(object)

		expect(graph.haveDependent(dep._graph)).to.equal(false)
	end,
	should_destroy_the_current_value = function(expect)
		local part = Instance.new("Part")
		part.Parent = workspace
		local dep = Hold(part, function(old, new, isDestroying)
			if isDestroying then
				old:Destroy()
				return false
			end

			return true
		end)

		destroyObject(dep)
		expect(part.Parent).to.equal(nil)
	end,
	should_destroy_dependents = function(expect)
		local part = Instance.new("Part")
		part.Parent = workspace

		local dep = Hold(100, returner(true))
		local _ = Compute(function(use)
			use(dep)
			return part
		end, function(old, new, isDestroying)
			if isDestroying then
				old:Destroy()
				return false
			end

			return true
		end)

        destroyObject(dep)
        
        expect(part.Parent).to.equal(nil)
	end,
    should_not_be_able_to_index = function(expect)
        local dep = Hold(100, returner(true))
        destroyObject(dep)

        expect(function()
            local _ = dep._graph
        end).to.throw()

    end
}
