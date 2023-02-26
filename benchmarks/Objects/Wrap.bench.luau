local Vinum = require(game.ReplicatedStorage.Vinum)
local Hold = Vinum.Objects.Hold
local Wrap = Vinum.Objects.Wrap
local update = Vinum.Utils.Grapher.updateGraph
local function alwaysTrue(...)
	return true
end

local signal = Instance.new("BindableEvent").Event
local values = {0}
local handler = function(_, new)
    return unpack(new)
end

return {
    {
		name = "creation",
		calls = 50_000,

		run = function()
			Wrap(signal, values, handler, alwaysTrue)
		end,
	},
}