---
sidebar_position: 1
---

# Matching State

Sometimes, you need to switch to certain computations depending on another object's value. The responsible object for this is `Match`. Additionally, they are also equiped with the same injectors that Calc is equiped with- so you can use the matches the same as calcs to an extent.

```lua
local Holder = Hold(100, Vinum.AlwaysTrue)
local Matcher = Match(Holder, {
    [100] = function(useState, useKeyState)
        return true
    end,
    ["default"] = function(useState, useKeyState)
        return false
    end,
}, function(oldValue, newValue)
    return true
end)

print(Matcher:get()) -- true
```

## Usage

To use Match, we first have to import it:
```lua
local Match = Vinum.Match
```

Now to create a Match object, we pass to its constructor an input state, a list of cases, and a stateful processors *(see [Processors](../Basics/Processors.md))*:
```lua
local Holder = Hold(true, Vinum.AlwaysTrue)
local Matcher = Match(Holder, {
    [true] = function(useState, useKeyState)
        return 100
    end,
    ["default"] = function(useState, useKeyState)
        return 0
    end
}, Vinum.RefuseIfSimilar)
```

:::caution
The `default` key has to be present in every Match usage- otherwise, it can error.
:::

And now, to read from this Match, we use its `get` method:
```lua
print(Matcher:get()) -- 100
```
______

## Why Matches

It is very possible to implement Matches using Calcs, however there are dozens of issues that will appear as we continue reinventing Matches using Calcs, and we can illustrate them using an example like this:
```lua
local root = Hold(true, Vinum.AlwaysTrue)
local matchUsingCalc = Calc(function(useState, useKeyState)
    local rootValue = useState(root)

    if rootValue == true then
        return 100
    else
        return 0
    end
end, Vinum.AlwaysTrue)
```
This example pretty simple, however, what if we were to add dependencies and more cases to this example- something like this:
```lua
local firstValue = Hold(213123, Vinum.AlwaysTrue)
local secondValue = Hold(4234, Vinum.AlwaysTrue)
local root = Hold(1, Vinum.AlwaysTrue)
local matchUsingCalc = Calc(function(useState, useKeyState)
    local rootValue = useState(root)

    if rootValue == 1 then
        return 1 * (useState(firstValue) * useState(secondValue))
    elseif rootValue == 2 then
        return 2 * (useState(firstValue) * useState(secondValue))
    elseif rootValue == 3 then
        return 3 * (useState(firstValue) * useState(secondValue))
    else
        return 1 * (useState(firstValue) + useState(secondValue))
    end
end, Vinum.AlwaysTrue)
```

There are a few issues with this:
* Not O(1) - This means that our code will be spend much more time searching for the right value to return/compute.
* to human & logical bugs
* Our code will become very messy when we add more dependencies
* Sometimes we have specific-case code and we want that to be properly saparated from the main handler.

Using Matches, these are greatly fixed:
```lua
local firstValue = Hold(213123, Vinum.AlwaysTrue)
local secondValue = Hold(4234, Vinum.AlwaysTrue)
local root = Hold(1, Vinum.AlwaysTrue)

local matcher = Match(root, {
    [1] = function(useState)
        return 1 * (useState(firstValue) * useState(secondValue))
    end,
    [2] = function(useState)
        return 2 * (useState(firstValue) * useState(secondValue))
    end,
    [3] = function(useState)
        return 3 * (useState(firstValue) * useState(secondValue))
    end,
    ["default"] = function(useState)
        return 0 + (useState(firstValue) + useState(secondValue))
    end
}, Vinum.AlwaysTrue)
```

Now, all the issues are fixed:
* Constant Case Search - Case searching in Matches is blazingly fast since its complexity is O(2) worst case, and best case O(1).
* Match manages all the stuff for you
* Our code is more readable
* Each case-specific code is in its own function- making removing them a lot more easier


Sometimes, we want to directly return state object's value in all cases, and while Matches are a decent tool for that, Vinum offers a more specialized tool for that, which is `Mirror`- an object that you will be introduced to in the next section.