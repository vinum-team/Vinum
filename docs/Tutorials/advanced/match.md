# Matching State
In this tutorial, you will be introduced to a new object that is `Match`. This object allows you to perform multiple computation depending on an InputState.

We first need to import the constructor:

```lua
local Match = Vinum.Match
```

And to create a Match object, we need to feed a state object that is ***stateful*** *(Check `Processors` for more info)*, and a list of *cases*. Finally, an update processor:

```lua
local level_100_tag = Hold("Fighter", Vinum.JustOk)
local level = Hold(100, Vinum.JustOk)
local tag = Match(level, {
    [100] = function(useState, useKeyState)
        return useState(level_100_tag)
    end,
    ["default"] = function(useState, useKeyState)
        return "NotFound"
    end
}, function(oldValue, newValue)
    return true
end)
```
??? Warning "Processor"
    Just like Calc, Match's creation uses the same pipeline when updating them, as such, your updateProcessor will get invoked during creation. This means you have to account for that. Vinum helps you by setting `oldValue` as `{type = "Symbol", value = "None}` on creation.


As you can see, We can perform computations similar to `Calc`, in fact, `Match` act as a multi-arm calc, where it manages "multiple calcs" at the same, and optimize them.

To get a value from a Match, we use its `...:get()` helper:
```lua
print(tag:get()) -- Fighter
```

If we changed `level_100_tag` state object to something else, our Match will recompute to ***match*** it. 

```lua
level_100_tag:set("HelloNoob")
print(tag:get()) -- "HellowNoob"
```

And if we changed the `inputState` value to something else, Match will recompute and choose a case that matches the new value, otherwise it will default to the "default" case:

```lua
level:set(40) -- an unsupported case
print(tag:get()) -- NotFound, which is provided by the "default" case.
```

!!! note
    As an optimization, Match will not recompute due to changes performed by dependencies that aren't related to the current case.

    This works since once `inputState` changes its value, Match will do a recompute anyway, so there is no need to perform unneeded computations

_____

# Why not a Calc?

You may be wondering, why not use a Calc for this case?

Consider the following example - The intent here is to exactly implement the same "level tags" system we created above.

```lua
local level_100_tag = Hold("Fighter", Vinum.JustOk)
local level = Hold(100, Vinum.JustOk)

local tag = Calc(function(useState, useKeyState)
    local currentLevel = useState(level)

    return (currentLevel == 100) and useState(level_100_tag) or "NotFound"
end, Vinum.JustOk)

print(tag:get()) -- Fighter
```

This works, although there a few problems with this:

* If `currentLevel` isn't even equal to 100, any changes to `level_100_tag` will cause an unneeded computation, making no difference in its value.
* Our code will become very messy when we add more dependencies
* Not O(1) - This means that our code will be spend much more time searching for the right value to return/compute.
* Prone to human & logical bugs

Using `Match`, it eliminated these problems:

* It will not recompute if a dependency that isn't related to the current case changes.
* Our code is understandable and easier to reason about at the first glance
* O(1)/O(2) - Our code is guaranteed to find our desired case in 1 or 2 steps.
* Chances of a logical bug is very slim, as it uses a specific mechanism that is heavily tested under many conditions.