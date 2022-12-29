local Vinum = require(game.ReplicatedStorage.Vinum)
local read = Vinum.read

return {
	["Should create a calc object"] = function(tester)
		local expect = tester.expect

		local calc = Vinum.Calc(function()
			return true
		end, Vinum.AlwaysTrue)

		expect(calc).to.be.a("table")
		expect(calc.type).to.equal("state")
		expect(calc.kind).to.equal("calc")
	end,
	["Should recompute once a dependency value changes"] = function(tester)
		local expect = tester.expect

		local hold = Vinum.Hold(100, Vinum.AlwaysTrue)
		local calc = Vinum.Calc(function(useState)
			return useState(hold) + 100
		end, Vinum.AlwaysTrue)

		expect(read(calc)).to.equal(200)
		hold:set(50)
		expect(read(calc)).to.equal(150)
	end,
	["Should dismiss an update"] = function(tester)
		local expect = tester.expect
		local flag = false

		local hold = Vinum.Hold(100, Vinum.AlwaysTrue)
		local calc = Vinum.Calc(function(useState)
			return useState(hold) + 100
		end, function()
			if flag then
				return false
			else
				flag = true
				return true
			end
		end)

		expect(read(calc)).to.equal(200)
		hold:set(0)
		expect(read(calc)).to.equal(200)
	end,
	["Should simplify dependency trees"] = function(tester)
		local expect = tester.expect

		local root = Vinum.Hold(100, Vinum.AlwaysTrue)
		local b = Vinum.Calc(function(useState)
			return useState(root) + 2
		end, Vinum.AlwaysTrue)

		local flags = 0
		local _ = Vinum.Calc(function(useState)
			flags += 1
			return useState(root) + useState(b)
		end, Vinum.AlwaysTrue)

		root:set(20)
		expect(flags).to.equal(2)
	end,
	["Should work with groups"] = function(tester)
		local expect = tester.expect

		local root = Vinum.Group({}, Vinum.AlwaysTrue)

		root:setKey("Hi", 200)
		local obj = Vinum.Calc(function(_, useKey)
			return useKey(root, "Hi") * 2
		end, Vinum.AlwaysTrue)

		expect(read(obj)).to.equal(400)

		root:setKey("Hi", 100)
		expect(read(obj)).to.equal(200)
	end,
	["Should work with observes"] = function(tester)
		local expect = tester.expect

		local root = Vinum.Group({}, Vinum.AlwaysTrue)

		root:setKey("Hi", 200)
		local obj = Vinum.Calc(function(_, useKey)
			return useKey(root, "Hi") * 2
		end, Vinum.AlwaysTrue)

		local flags = 0

		local x
		Vinum.Observe(obj, Vinum.AlwaysTrue):onChange(function(newValue)
			flags += 1
			x = newValue
		end)

		root:setKey("Hi", 2)
		expect(x).to.equal(4)
		expect(flags).to.equal(1)
	end,
}
