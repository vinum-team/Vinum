--!strict
local Vinum = require(game.ReplicatedStorage.Vinum)
local Hold = Vinum.Objects.Hold
local Read = Vinum.Utils.read
local Write = Vinum.Utils.write

local function alwaysTrue()
	return true
end
type expect = (any) -> any
return {
	["should create a Hold"] = function(expect: expect)
		local holder = Hold("hi", alwaysTrue)

		expect(holder.type).to.equal("state")
		expect(holder.kind).to.equal("hold")
		expect(holder).to.be.a("table")
	end,
	["should be able to read from"] = function(expect: expect)
		local holder = Hold("hi", alwaysTrue)

		expect(Read(holder)).to.equal("hi")
	end,
	["should be able to write to"] = function(expect: expect)
		local holder = Hold("hi", alwaysTrue)

		Write(holder, "123")
		expect(Read(holder)).to.equal("123")
	end,
	["should dismiss updates when processor rejects"] = function(expect: expect)
		local holder = Hold("hi", function()
			return false
		end)

		Write(holder, "h")
		expect(Read(holder)).to.equal("hi")
	end,
}
