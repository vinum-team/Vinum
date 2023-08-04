local Vinum = require(game.ReplicatedStorage.Vinum)

local Hold = Vinum.Hold
local KeyOf = Vinum.KeyOf
local returner = function(value)
	return function()
		return value
	end
end
return {
	should_create_a_keyof = function(expect)
		expect(KeyOf(Hold({}, returner(true)), "j", returner(true)).meta).to.equal("KeyOf")
	end,
	should_update_keyof_when_source_updates = function(expect)
		local source = Hold({ key = 1 }, returner(true))
		local mirror = KeyOf(source, "key", returner(true))

		source:set({ key = 2 })
		expect(mirror:get()).to.equal(source:get().key)
	end,
	should_update_source_when_keyof_updates = function(expect)
		local source = Hold({ key = 1 }, returner(true))
		local mirror = KeyOf(source, "key", returner(true))

		mirror:set(2)
		expect(mirror:get()).to.equal(source:get().key)
	end,
}
