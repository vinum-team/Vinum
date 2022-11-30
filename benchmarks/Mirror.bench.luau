local Vinum = require(game.ReplicatedStorage.Vinum)

local Hold = Vinum.Hold 
local Mirror = Vinum.Mirror 
local JustOk = Vinum.JustOk 

return {
    {
        name = "creating a mirror object",
        calls = 50000,

        preRun = function()
            return Hold(true, JustOk), Hold(false, JustOk)
        end,

        run = function(x, y)
            Mirror(x, {
                ["default"] = y
            })
        end
    },
    {
        name = "updating a mirror object",
        calls = 50000,

        
        preRun = function()
            local x = Hold(true, JustOk)
            local y = Hold(false, JustOk)

            local miObj = Mirror(x, {
                ["default"] = y
            })

            miObj._currentCaseDependency = Hold("hi", JustOk)
            return miObj
        end,

        run = function(miObj)
           miObj:_update()
        end
    }
}