local Vinum = require(game.ReplicatedStorage.Vinum)

local wrapSource = Vinum.wrapSource 
local sourceObject = Vinum.sourceObject

local returner = function(value)
	return function()
		return value
	end
end

return {
	should_wrapSource_update_when_source_updates = function(expect)
        local src = sourceObject(function(self) end)
        local wrapper = wrapSource(src, function(_, new)
            return new
        end, returner(true))
        src:Fire(1, 2)

        expect(wrapper:get()[1]).to.equal(1)
        expect(wrapper:get()[2]).to.equal(2)
	end,
}
