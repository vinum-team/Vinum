local Vinum = require(game.ReplicatedStorage.Vinum)
local read = Vinum.read
local write = Vinum.write

return {
	["should construct a Match object"] = function(tester)
		local expect = tester.expect
		local root = Vinum.Hold(100, Vinum.AlwaysTrue)
		local obj = Vinum.Match(root, {
			[100] = function()
				return true
			end,
			["default"] = function() end,
		}, Vinum.AlwaysTrue)

		expect(obj).to.be.a("table")
		expect(obj.type).to.equal("state")
		expect(obj.kind).to.equal("match")
	end,
	["should recompute once the InputState changes"] = function(tester)
		local expect = tester.expect
		local root = Vinum.Hold(100, Vinum.AlwaysTrue)

		local flag = 0

		Vinum.Match(root, {
			[200] = function()
				flag += 1
				return true
			end,
			["default"] = function() end,
		}, Vinum.AlwaysTrue)

		write(root, 200)
		expect(flag).to.equal(1)
	end,
	["should recompute once a dependency changes"] = function(tester)
		local expect = tester.expect
		local root = Vinum.Hold(100, Vinum.AlwaysTrue)
		local another = Vinum.Hold(200, Vinum.AlwaysTrue)
		local obj = Vinum.Match(root, {
			[100] = function(use)
				return use(another) * 200
			end,
			["default"] = function() end,
		}, Vinum.AlwaysTrue)

		expect(read(obj)).to.equal(40000)
		write(another, 1)
		expect(read(obj)).to.equal(200)
	end,
}
