local Vinum = require("../../src")

local Hold = Vinum.Hold

local returner = function(value)
	return function()
		return value
	end
end
return {
	should_create_a_hold = function(skip, expect)
		expect(Hold(1, returner(true)).meta).to.equal("Hold")
	end,
	should_allow_updates_given_allowing_processor = function(skip, expect)
		local obj = Hold(1, returner(true))
		obj:set(12)
		expect(obj:get()).to.equal(12)
	end,
	shouldnt_allow_updates_given_disallowing_processor = function(skip, expect)
		local obj = Hold(1, returner(false))
		obj:set(12)
		expect(obj:get()).to.never.equal(12)
	end,
}
