local Vinum = require(game.ReplicatedStorage.Vinum)
local read = Vinum.read

local throwawaySignal = {
	_connections = {},
}

function throwawaySignal:Connect(fn)
	self._connections[fn] = true
end

function throwawaySignal:fire(...)
	for fn in self._connections do
		fn(...)
	end
end
return {
	["Should construct a wrap object"] = function(tester)
		local expect = tester.expect

		local wrapState = Vinum.Wrap({ Connect = function() end }, { 0 }, function(...)
			return ...
		end)

		expect(wrapState).to.be.a("table")
		expect(wrapState.type).to.equal("state")
		expect(wrapState.kind).to.equal("wrap")
	end,
	["Should hold values initially"] = function(tester)
		local expect = tester.expect

		local wrapState = Vinum.Wrap({ Connect = function() end }, { 0 }, function(...)
			return ...
		end)
		expect(read(wrapState, 1)).to.equal(0)
	end,
	["Should change as the given event fires"] = function(tester)
		local expect = tester.expect

		local wrapState = Vinum.Wrap(throwawaySignal, { 0, 0 }, function(...)
			return ...
		end)

		throwawaySignal:fire(2, 3)
		expect(read(wrapState, 1)).to.equal(2)
		expect(read(wrapState, 2)).to.equal(3)
	end,
}
