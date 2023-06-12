--!strict

local vinum = require(game.ReplicatedStorage.Vinum)
local Compute = vinum.Compute
local Hold = vinum.Hold
local KeyOf = vinum.KeyOf

local function returner(value)
	return function()
		return value
	end
end

local health = Hold(100, returner(true))

local computedStore = Compute(function(inject)
	return {
		doubledHealth = inject(health) * 2,
		humanoidState = "Running",
	}
end, returner(true))

print(KeyOf(computedStore, "doubledHealth", returner(true)):get())

