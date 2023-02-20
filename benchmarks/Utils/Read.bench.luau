--!strict
local Vinum = require(game.ReplicatedStorage.Vinum)
local Read = Vinum.Utils.Read

local stateEmu = {
	_getValue = function()
		return 1
	end,
}

return {
	{
		name = "reading state",
		calls = 50_000,

		run = function()
			Read(stateEmu)
		end,
	},
	{
		name = "reading constants",
		calls = 50_000,

		run = function()
			Read(1)
		end,
	},
}
