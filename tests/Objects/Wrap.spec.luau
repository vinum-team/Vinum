local Vinum = require(game.ReplicatedStorage.Vinum)
local Read = Vinum.Utils.read
local Write = Vinum.Utils.write
local Wrap = Vinum.Objects.Wrap
local Hold = Vinum.Objects.Hold

local Signal = Instance.new("BindableEvent")

return {
    ["should recompute once the event fires"] = function(expect: any)
        local Wrapper = Wrap(Signal.Event, {0}, function(old, new)
            return old[1] + new[1]
        end, Vinum.Processors.AlwaysTrue)

        Signal:Fire(1)
        expect(Read(Wrapper, 1)).to.equal(1)
    end,
    ["should recompute once the event changes"] = function(expect)
        local signalObj = Hold(Signal.Event, Vinum.Processors.AlwaysTrue)
        local Wrapper = Wrap(signalObj, {0}, function(old, new)
            return old[1] + new[1]
        end, Vinum.Processors.AlwaysTrue)

        Write(signalObj, Instance.new("BindableEvent").Event)

        Signal:Fire(1)
        expect(Read(Wrapper, 1)).to.equal(0)
    end

}