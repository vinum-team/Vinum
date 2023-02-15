--!strict
local Vinum = require(game.ReplicatedStorage.Vinum)
local Hold = Vinum.Objects.Hold
local Observe = Vinum.Objects.Observe
local Read = Vinum.Utils.Read
local Write = Vinum.Utils.Write

local function alwaysTrue(...)
	return true
end
type expect = (any) -> any
return {
	["should create an Observe"] = function(expect: expect)
		local observer = Observe(Hold("hi", alwaysTrue), alwaysTrue)

		expect(observer.type).to.equal("state")
		expect(observer.kind).to.equal("observe")
		expect(observer).to.be.a("table")
	end,

	["should dismiss updates when processor rejects"] = function(expect: expect)
		local holder = Hold("hi", alwaysTrue)
		local observer = Observe(holder, function()
			return false
		end)

		local flag = true
		observer:onChange(function(newValue)
			flag = false			
		end)

		Write(holder, "123")
		expect(flag).to.equal(true)
	end,
	["should fire connections"] = function(expect: expect)
		local holder = Hold("hi", alwaysTrue)
		local observer = Observe(holder, alwaysTrue)

		local value = "d"

		observer:onChange(function(newValue)
			value = newValue
		end)

		Write(holder, "sup")

		expect(value).to.equal(Read(holder))
	end
}
