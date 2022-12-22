local Vinum = require(game.ReplicatedStorage.Vinum)

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

		local wrapState = Vinum.Wrap({ Connect = function() end }, 1, 123)

		expect(wrapState).to.be.a("table")
		expect(wrapState.type).to.equal("state")
		expect(wrapState.kind).to.equal("wrap")
	end,
	["Should hold values initially"] = function(tester)
		local expect = tester.expect

		local wrapState = Vinum.Wrap(game.AncestryChanged, 1, 123, 334, 45)
		expect(wrapState:get()).to.equal(123)
	end,
	["Should change as the given event fires"] = function(tester)
		local expect = tester.expect

		local wrapState1, wrapState2 = Vinum.Wrap(throwawaySignal, 2, 123, 4)

		throwawaySignal:fire(2, 3)
		expect(wrapState1:get()).to.equal(2)
		expect(wrapState2:get()).to.equal(3)
	end,
}
