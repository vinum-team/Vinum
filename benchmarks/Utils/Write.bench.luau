--!strict
local Vinum = require(game.ReplicatedStorage.Vinum)
local Write = Vinum.Utils.write

local stateEmu = {
	_setValue = function(new)
		return true
	end,
}

return {
	{
		name = "writing state",
		calls = 50_000,

		run = function()
			Write(stateEmu :: any)
		end,
	},
}
