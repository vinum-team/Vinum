local Vinum = require(game.ReplicatedStorage.Vinum)
local read = Vinum.read
local write = Vinum.write

return {
    ["Should create a progress"] = function(tester)
        local expect = tester.expect

        local obj = Vinum.Progress(100, function()end, Vinum.Processors.AlwaysTrue)

        expect(obj).to.be.a("table")
		expect(obj.type).to.equal("state")
		expect(obj.kind).to.equal("progress")
    end,
    ["Become should work"] = function(tester)
        local expect = tester.expect

        local prog = Vinum.Progress(0, function(use, become)
            task.wait(3)
            become(100)
            task.wait(4)
            return 10
        end, Vinum.Processors.AlwaysTrue)

        expect(read(prog)).to.equal(0)
        task.wait(3)
        expect(read(prog)).to.equal(100)
    end,
    ["Dependencies should reupdate"] = function(tester)
        local expect = tester.expect

        local root = Vinum.Hold(100, Vinum.Processors.AlwaysTrue)
        local flag = 0
        local prog = Vinum.Progress(0, function(use, become)
            use(root)
            flag += 1

            task.wait(4)
            return 50
        end, Vinum.Processors.AlwaysTrue)       

        write(root, 100)
        expect(flag).to.equal(2)
        expect(read(prog)).to.equal(0)
    end,
    ["Dependents should be updated"] = function(tester)
        local expect = tester.expect

        local prog = Vinum.Progress(0, function(_, become)
            task.wait(2)
            become(50)
            task.wait(4)
            return 100
        end, Vinum.Processors.AlwaysTrue)

        local newValue = 0
        Vinum.Observe(prog, Vinum.Processors.AlwaysTrue):onChange(function(n)
            newValue = n
        end)
        task.wait(2)
        expect(newValue).to.equal(50)
        task.wait(4)
        expect(newValue).to.equal(100)
    end
}