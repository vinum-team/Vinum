
local shouldTest = true

local Tester = require(script.Parent.Tester)

if shouldTest then
    Tester.bootstrapper:start({
        directories = {game.ReplicatedStorage.tests},
        options = {
            context = Tester
        }
    })
end