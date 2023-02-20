--!strict
local Vinum = require(game.ReplicatedStorage.Vinum)
local Group = Vinum.Objects.Group
local Read = Vinum.Utils.Read
local WriteIndex = Vinum.Utils.WriteIndex

local function alwaysTrue()
	return true
end

return {
	["should create a Group"] = function(expect: any)
		local grouped = Group({}, alwaysTrue)

		expect(grouped.type).to.equal("state")
		expect(grouped.kind).to.equal("group")
		expect(grouped).to.be.a("table")
	end,
	["should be able to read from"] = function(expect: any)
		local grouped = Group({
			name = "hello",
		}, alwaysTrue)

		expect(Read(grouped, "name")).to.equal("hello")
	end,
	["should be able to write to"] = function(expect: any)
		local grouped = Group({}, alwaysTrue)

		WriteIndex(grouped, "name", 123)

		expect(Read(grouped, "name")).to.equal(123)
	end,
}
