local Vinum = require(game.ReplicatedStorage.Vinum)
local read = Vinum.read
local write = Vinum.write

return {
	["Should create a calc object"] = function(tester)
		local expect = tester.expect

		local calc = Vinum.Calc(function()
			return true
		end, Vinum.Processors.AlwaysTrue)

		expect(calc).to.be.a("table")
		expect(calc.type).to.equal("state")
		expect(calc.kind).to.equal("calc")
	end,
	["Should recompute once a dependency value changes"] = function(tester)
		local expect = tester.expect

		local hold = Vinum.Hold(100, Vinum.Processors.AlwaysTrue)
		local calc = Vinum.Calc(function(use)
			return use(hold) + 100
		end, Vinum.Processors.AlwaysTrue)

		expect(read(calc)).to.equal(200)
		write(hold, 50)
		expect(read(calc)).to.equal(150)
	end,
	["Should dismiss an update"] = function(tester)
		local expect = tester.expect
		local flag = false

		local hold = Vinum.Hold(100, Vinum.Processors.AlwaysTrue)
		local calc = Vinum.Calc(function(use)
			return use(hold) + 100
		end, function()
			if flag then
				return false
			else
				flag = true
				return true
			end
		end)

		expect(read(calc)).to.equal(200)
		write(hold, 0)
		expect(read(calc)).to.equal(200)
	end,
	["Should simplify dependency trees"] = function(tester)
		local expect = tester.expect

		local root = Vinum.Hold(100, Vinum.Processors.AlwaysTrue)
		local b = Vinum.Calc(function(use)
			return use(root) + 2
		end, Vinum.Processors.AlwaysTrue)

		local flags = 0
		local _ = Vinum.Calc(function(use)
			flags += 1
			return use(root) + use(b)
		end, Vinum.Processors.AlwaysTrue)

		write(root, 20)
		expect(flags).to.equal(2)
	end,
	["Should work with groups"] = function(tester)
		local expect = tester.expect

		local root = Vinum.Group({
			Hi = 200,
		}, Vinum.Processors.AlwaysTrue)

		local obj = Vinum.Calc(function(use)
			return use(root, "Hi") * 2
		end, Vinum.Processors.AlwaysTrue)

		expect(read(obj)).to.equal(400)
		write(root, "Hi", 100)
		expect(read(obj)).to.equal(200)
	end,
	["Should work with observes"] = function(tester)
		local expect = tester.expect

		local root = Vinum.Group({
			Hi = 200,
		}, Vinum.Processors.AlwaysTrue)

		local obj = Vinum.Calc(function(use)
			return use(root, "Hi") * 2
		end, Vinum.Processors.AlwaysTrue)

		local flags = 0

		local x
		Vinum.Observe(obj, Vinum.Processors.AlwaysTrue):onChange(function(newValue)
			flags += 1
			x = newValue
		end)

		write(root, "Hi", 2)
		expect(x).to.equal(4)
		expect(flags).to.equal(1)
	end,
}
