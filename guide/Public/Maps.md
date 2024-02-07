# Maps
Maps are native deriveds with a computer function that allows the derived to act as a switch-like state object. 

You can create one like so:
```lua
local mySource = scope:Source(10)
scope:Map(mySource, {
    [10] = 20,
    ["default"] = scope:Derived(function(RNode)
        return Use(RNode, mySource) + 10
    end)
})
```

Any other Operators that work on Deriveds also work on Maps.