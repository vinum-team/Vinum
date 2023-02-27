--!strict
local Vinum = require(game.ReplicatedStorage.Vinum)
local Read = Vinum.Utils.read
local Write = Vinum.Utils.write
local Compute = Vinum.Objects.Compute
local Hold = Vinum.Objects.Hold

local function alwaysTrue()
	return true
end

return {
	["should update when a dependency updates"] = function(expect: any)
		local holder = Hold(100, alwaysTrue)
		local computer = Compute(function(use)
			return `{use(holder)} + 100 = {Read(holder) + 100}`
		end, alwaysTrue)

		Write(holder, 200)
		expect(Read(computer)).to.equal("200 + 100 = 300")
	end,
}
