local Vinum = require(game.ReplicatedStorage.Vinum)
local Hold = Vinum.Objects.Hold
local Absorb = Vinum.Objects.Absorb 

local function alwaysTrue(...)
    return true
end

local toAbsorb = Hold(100, alwaysTrue)
local isSynced = Hold(true, alwaysTrue)
local caseList = {
    [100] = Hold(100, alwaysTrue),
    ["default"] = function()
        return 200
    end
}

game:GetService("RunService").Heartbeat:Connect(function()
    Absorb(toAbsorb, caseList, isSynced, alwaysTrue)
end)