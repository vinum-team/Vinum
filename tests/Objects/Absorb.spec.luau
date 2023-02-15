--!strict
local Vinum = require(game.ReplicatedStorage.Vinum)
local Read = Vinum.Utils.Read
local Write = Vinum.Utils.Write
local Absorb = Vinum.Objects.Absorb 
local Hold = Vinum.Objects.Hold 

local function alwaysTrue()
    return true
end

return {
    ["should work with all type of inputs"] = function(expect: any)
        local holder = Hold(100, alwaysTrue)
        local anotherHolder = Hold("200", alwaysTrue)
        local absorber = Absorb(holder, {
            [100] = anotherHolder,
            [200] = function()
                return "400"
            end,
        }, Hold(true, alwaysTrue), alwaysTrue)

        expect(Read(absorber)).to.equal("200")
        Write(holder, 200)
        Write(anotherHolder, "300")
        expect(Read(absorber)).to.equal("400")

        Write(holder, 100)
        expect(Read(absorber)).to.equal("300")
    end,
    ["should dynamically link dependencys from functions"] = function(expect)
        local holder = Hold(200, alwaysTrue)
        local anotherHolder = Hold("200", alwaysTrue)
        local absorber = Absorb(holder, {
            [200] = function(use)
                return use(anotherHolder)
            end,
        }, Hold(true, alwaysTrue), alwaysTrue)

        expect(Read(absorber)).to.equal("200")
        Write(anotherHolder, "100")
        expect(Read(absorber)).to.equal("100")

    end
}