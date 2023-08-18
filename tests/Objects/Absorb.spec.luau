--!strict
local Vinum = require("../../src")

local Hold = Vinum.Hold
local Absorb = Vinum.Absorb

local returner = function(value)
	return function()
		return value
	end
end

return {
	should_update_when_toabsorb_updates = function(skip, expect)
		local constant = Hold(1, returner(true))
		local absorber = Absorb(constant, {
			[2] = Hold(2, returner(true)),
			default = constant,
		}, returner(true))

		expect(absorber:get()).to.equal(1)
		constant:set(2)
		expect(absorber:get()).to.equal(2)
	end,
	should_update_when_lastArm_updates = function(skip, expect)
		local constant = Hold(1, returner(true))
		local dep = Hold(2, returner(true))
		local absorber = Absorb(constant, {
			[1] = dep,
			default = constant,
		}, returner(true))

		dep:set(3)
		expect(absorber:get()).to.equal(3)
	end,
}
