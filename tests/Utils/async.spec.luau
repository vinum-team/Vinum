
local Vinum = require(game.ReplicatedStorage.Vinum)

local async = Vinum.async 
return {
    should_fire_listener_when_finished = function(expect)
        local flag = false

        async(function()
            task.wait(1)
        end):on(function()
            flag = true 
        end)

        task.wait(1)
        expect(flag).to.equal(true)
    end,
    should_return_data = function(expect)
        local extractedData 
        async(function()
            return "hi"
        end):on(function(data)
            extractedData = data
        end)

        expect(extractedData).to.equal("hi")
    end,
    should_fire_listeners_when_process_finished_before_listener_connection = function(expect)
        local didFire = false
        
        async(function()end):on(function(data)
            didFire = true
        end)

        expect(didFire).to.equal(true)
    end,
    should_cancel_correctly = function(expect)
        local first_flag = false
        local second_flag = false

        local ASOP = async(function()
            first_flag = true
            task.wait(1)
            second_flag = true
        end)
        ASOP:cancel()
        task.wait(1)

        expect(first_flag).to.equal(true)
        expect(second_flag).to.equal(false)
    end

}