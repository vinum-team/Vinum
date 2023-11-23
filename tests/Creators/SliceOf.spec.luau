--!strict
local Vinum = require("../../src")

return {
    should_update_when_update_is_received = function(_, expect)
        local Dep = Vinum.Value {
            {value = 10}            
        }
        local value = Vinum.SliceOf(Dep, "value")

        Vinum.Write(Dep, {value = 20})
        expect(Vinum.Read(value)).to.equal(20)
    end
}